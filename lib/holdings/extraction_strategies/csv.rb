# frozen_string_literal: true

require 'csv'

module Holdings
  module ExtractionStrategies
    class CSV < Base
      def extract # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        csv.map do |row| # rubocop:disable Metrics/BlockLength
          exchange = Assets::Exchange.find_or_create_by(name: row[:exchange])
          identity = if row[:ticker].present?
                       if asset_type(row[:asset_class]) == 'CashEquivalent' && row[:market_currency].present?
                         Assets::Currency.find_or_initialize_by(currency: row[:market_currency])
                       else
                         Assets::Ticker.find_or_initialize_by(ticker: row[:ticker], exchange:)
                       end
                     elsif row[:isin].present?
                       Assets::ISIN.find_or_initialize_by(isin: row[:isin], exchange:)
                     end
          asset = Asset.find_or_create_by!(asset_class: asset_type(row[:asset_class]), name: row[:name], sector: row[:sector])
          identity.update(asset:)

          asset_price = asset.asset_prices.build
          case asset_price
          when Holdings::EquityPrice
            asset_price.update(notional_value_cents: (row[:notional_value].to_d * 100).to_i,
                               notional_value_currency: row[:currency],
                               unit_price_cents: row[:price].present? ? (row[:price].to_d * 100).to_i : 0,
                               unit_price_currency: row[:currency],
                               market_price_cents: (row[:market_price] || row[:market_value]).to_d * 100,
                               market_price_currency: row[:market_currency])
          when Holdings::BondPrice
            asset_price.update
          end

          price = asset.prices.build(date:)
          price.priceable = asset_price
          quantity = row[:shares].to_d

          fund.holdings.build(date:, quantity:, price:, accrual_date: row[:accrual_date])
        end
      end

      private

      def csv
        @csv ||= ::CSV.new rows, headers: true, converters: :numeric, header_converters: :symbol
      end

      def rows
        @rows ||= (body.lines.drop(9) - body.lines.drop(9).slice(-12, 12)).join
      end

      def date
        @date ||= Date.parse(body.lines[1].split('"')[1])
      end

      def body
        @body ||= @file.open(&:read)
      end
    end
  end
end
