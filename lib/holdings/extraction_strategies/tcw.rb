# frozen_string_literal: true

module Holdings
  module ExtractionStrategies
    class TCW < Excel
      HEADINGS = [
        :etf_ticker,
        :date,
        :isin, :cusip, :sedol, :ticker,
        :description,
        :security_type,
        :market_value,
        :maturity_date,
        :shares,
        :security_price,
        :asset_currency,
        :shares_outstanding,
        :total_net_assets,
        :market_value_weight
      ].freeze
      ROWS_TO_DROP = 1
      ROWS_TO_SLICE = 0

      def date
        @date ||= Date.parse(worksheet[1][1].value)
      end

      def extract_holdings # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
        working_sheet.map do |row|
          asset = Asset.find_or_create_by!(name: row[:description], asset_class: asset_type(row[:security_type]))

          Assets::Ticker.find_or_create_by(asset:, ticker: row[:ticker]) if row[:ticker] != 'n/a'
          Assets::Currency.find_or_create_by(asset:, currency: row[:asset_currency]) if asset_type(row[:security_type]) == 'CashEquivalent' && row[:asset_currency].present?
          Assets::CUSIP.find_or_create_by(asset:, cusip: row[:cusip]) if row[:cusip].present?
          Assets::SEDOL.find_or_create_by(asset:, sedol: row[:sedol]) if row[:sedol].present?
          Assets::ISIN.find_or_create_by(asset:, isin: row[:isin]) if row[:isin].present?

          holding = portfolio.holdings.build(date:, asset:, quantity: row[:shares].to_d,
                                             notional_value_cents: (row[:market_value].to_d * 100).to_i,
                                             notional_value_currency: row[:asset_currency],
                                             market_value_cents: (row[:market_value].to_d * 100).to_i,
                                             market_value_currency: row[:asset_currency])

          holding.priceable = asset.prices.find_or_initialize_by(price_cents: (row[:security_price].to_d * 100).to_i,
                                                                 price_currency: row[:asset_currency])

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
