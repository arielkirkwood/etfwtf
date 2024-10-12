# frozen_string_literal: true

module Holdings
  module ExtractionStrategies
    class StateStreet < Excel
      HEADINGS = [
        :name,
        :ticker,
        :identifier,
        :sedol,
        :weight,
        :sector,
        :shares_held,
        :local_currency
      ].freeze
      ROWS_TO_DROP = 5
      END_OF_DATA_STRING = 'Past performance is'

      def date
        @date ||= Date.parse(workbook[0][2][1].value.split('As of ').last)
      end

      def extract_holdings # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        working_sheet.map do |row|
          break if row[:name].present? && row[:name].starts_with?(END_OF_DATA_STRING)
          next if row[:name].blank?

          asset = if (ticker = Assets::Ticker.where(ticker: row[:ticker]).first)
                    ticker.asset
                  elsif (cusip = Assets::CUSIP.where(cusip: row[:identifier]).first)
                    cusip.asset
                  elsif (sedol = Assets::SEDOL.where(sedol: row[:sedol]).first)
                    sedol.asset
                  end
          asset = Asset.find_or_create_by!(name: row[:name], asset_class: 'Equity') if asset.blank?

          Assets::Ticker.find_or_create_by(asset:, ticker: row[:ticker]) if row[:ticker].present?
          Assets::CUSIP.find_or_create_by(asset:, cusip: row[:identifier]) if row[:cusip].present?
          Assets::SEDOL.find_or_create_by(asset:, sedol: row[:sedol]) if row[:sedol].present?

          holding = portfolio.holdings.build(date:, asset:, quantity: row[:shares_held].to_d,
                                             # notional_value_cents: (row[:market_value].to_d * 100).to_i,
                                             notional_value_currency: row[:local_currency],
                                             # market_value_cents: (row[:market_value].to_d * 100).to_i,
                                             market_value_currency: row[:local_currency])

          holding.priceable = asset.prices.find_or_initialize_by(price_cents: 0, # State Street doesn't supply price data
                                                                 price_currency: row[:local_currency])

          holding
        end
      end
    end
  end
end
