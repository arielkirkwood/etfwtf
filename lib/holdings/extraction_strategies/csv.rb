# frozen_string_literal: true

require 'csv'

module Holdings
  module ExtractionStrategies
    class CSV < Base
      def date
        @date ||= Date.parse(body.lines[1].split('"')[1])
      end

      def holdings_count
        @holdings_count ||= set_holdings_count
      end

      def extract_holdings # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        csv.map do |row| # rubocop:disable Metrics/BlockLength
          exchange = Markets::Exchange.iterated_search(row[:exchange]).first if row[:exchange].present? && row[:exchange].length > 2
          asset = Asset.find_or_create_by!(asset_class: asset_type(row[:asset_class]), name: row[:name], sector: row[:sector], exchange:)

          identity = if row[:ticker].present?
                       if asset_type(row[:asset_class]) == 'CashEquivalent' && row[:market_currency].present?
                         Assets::Currency.find_or_initialize_by(currency: row[:market_currency])
                       else
                         Assets::Ticker.find_or_initialize_by(ticker: row[:ticker])
                       end
                     elsif row[:isin].present?
                       Assets::ISIN.find_or_initialize_by(isin: row[:isin])
                     end
          identity.update(asset:)

          accrual_date = nil
          if row[:accrual_date].present?
            begin
              accrual_date = Date.parse(row[:accrual_date])
            rescue Date::Error
              accrual_date = nil
            end
          end

          holding = portfolio.holdings.build(date:, asset:, quantity: row[:shares].to_d, accrual_date:,
                                             notional_value_cents: (row[:price].to_d * 100).to_i,
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

      def csv
        @csv ||= ::CSV.new csv_string, headers: true, converters: :numeric, header_converters: :symbol
      end

      def csv_string
        rows.join
      end

      def set_holdings_count
        count = csv.count
        csv.rewind

        count
      end

      def rows
        @rows ||= (body.lines.drop(9) - body.lines.drop(9).slice(-12, 12))
      end

      def body
        @body ||= portfolio.holdings_file.open(&:read)
      end
    end
  end
end
