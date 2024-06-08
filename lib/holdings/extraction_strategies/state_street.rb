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
      ROWS_TO_DROP = 1
      ROWS_TO_SLICE = 0

      def date
        @date ||= Date.parse(workbook[0][2][1].value.split('As of ').last)
      end

      def extract_holdings # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        working_sheet.map do |row|
          asset = if (ticker = Assets::Ticker.where(ticker: row[:ticker]).first)
                    ticker.asset
                  elsif (cusip = Assets::CUSIP.where(cusip: row[:identifier]).first)
                    cusip.asset
                  elsif (sedol = Assets::SEDOL.where(sedol: row[:sedol]).first)
                    sedol.asset
                  end
          asset = Asset.find_or_create_by!(name: row[:description], asset_class: 'Equity') if asset.blank?

          Assets::CUSIP.find_or_create_by(asset:, cusip: row[:identifier]) if row[:cusip].present?
          Assets::SEDOL.find_or_create_by(asset:, sedol: row[:sedol]) if row[:sedol].present?

          holding = portfolio.holdings.build(date:, asset:, quantity: row[:shares_held].to_d,
                                             # notional_value_cents: (row[:market_value].to_d * 100).to_i,
                                             notional_value_currency: row[:local_currency],
                                             # market_value_cents: (row[:market_value].to_d * 100).to_i,
                                             market_value_currency: row[:local_currency])

          holding.priceable = asset.prices.find_or_initialize_by(price_cents: (row[:security_price].to_d * 100).to_i,
                                                                 price_currency: row[:local_currency])

          holding
        end
      end

      private

      def asset_type(asset_class) # rubocop:disable Metrics/MethodLength
        case asset_class
        when 'COMMON STOCK'
          'Equity'
        when 'CASH'
          'CashEquivalent'
        when 'FUTURES'
          'Derivative'
        when 'REIT - Real Estate Invesment Trust'
          'RealEstateInvestmentTrust'
        else
          raise Asset::UnknownTypeError, asset_class
        end
      end
    end
  end
end
