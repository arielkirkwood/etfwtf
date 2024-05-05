# frozen_string_literal: true

module Holdings
  module ExtractionStrategies
    class Ishares < CSV
      ROWS_TO_DROP = 9
      ROWS_TO_SLICE = 12

      def date
        @date ||= Date.parse(body.lines[1].split('"')[1])
      end

      def extract_holdings # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        csv.map do |row| # rubocop:disable Metrics/BlockLength
          exchange = Markets::Exchange.iterated_search(row[:exchange]).first if row[:exchange].present? && row[:exchange].length > 2
          asset = Asset.find_or_create_by!(asset_class: asset_type(row[:asset_class]), name: row[:name], sector: row[:sector], exchange:)

          Assets::Ticker.find_or_create_by(asset:, ticker: row[:ticker]) if row[:ticker].present?
          Assets::Currency.find_or_create_by(asset:, currency: row[:market_currency]) if asset_type(row[:asset_class]) == 'CashEquivalent' && row[:market_currency].present?
          Assets::CUSIP.find_or_create_by(asset:, cusip: row[:cusip]) if row[:cusip].present?
          Assets::SEDOL.find_or_create_by(asset:, sedol: row[:sedol]) if row[:sedol].present?
          Assets::ISIN.find_or_create_by(asset:, isin: row[:isin]) if row[:isin].present?

          accrual_date = nil
          if row[:accrual_date].present?
            begin
              accrual_date = Date.parse(row[:accrual_date])
            rescue Date::Error
              accrual_date = nil
            end
          end

          holding = portfolio.holdings.build(date:, asset:, quantity: row[:shares].to_d, accrual_date:,
                                             notional_value_cents: (row[:notional_value].to_d * 100).to_i,
                                             notional_value_currency: row[:currency],
                                             market_value_cents: (row[:market_value].to_d * 100).to_i,
                                             market_value_currency: row[:market_currency])

          # Initialize a blank one to get the type
          priceable = asset.prices.build
          # Then when we know the type, find-or-init with data
          case priceable
          when Holdings::EquityPrice
            priceable = asset.prices.find_or_initialize_by(price_cents: (row[:price].to_d * 100).to_i,
                                                           price_currency: row[:currency])
          when Holdings::BondPrice
            begin
              maturity_date = Date.parse(row[:maturity])
            rescue Date::Error
              maturity_date = nil
            end
            priceable = asset.prices.find_or_initialize_by(par_value_cents: (row[:par_value].to_d * 100).to_i,
                                                           par_value_currency: row[:currency],
                                                           coupon_rate: row[:coupon_rate].to_d,
                                                           maturity_date:)
          end
          holding.priceable = priceable

          holding
        end
      end

      private

      def set_holdings_count
        count = csv.count
        csv.rewind

        count
      end

      def asset_type(asset_class) # rubocop:disable Metrics/MethodLength
        case asset_class
        when 'Bond', 'Fixed Income'
          'Bond'
        when 'Cash', 'Cash Collateral and Margins'
          'CashEquivalent'
        when 'Derivatives', 'Futures'
          'Derivative'
        when 'Equity'
          'Equity'
        when 'FX'
          'ForexCurrency'
        when 'Money Market'
          'MoneyMarketFund'
        else
          raise Asset::UnknownTypeError, asset_class
        end
      end
    end
  end
end
