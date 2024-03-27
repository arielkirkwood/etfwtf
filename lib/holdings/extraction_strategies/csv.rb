# frozen_string_literal: true

module Holdings
  module ExtractionStrategies
    class CSV < Base
      def extract(file) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        file.csv.map do |row| # rubocop:disable Metrics/BlockLength
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
            asset_price.update(notional_value_cents: row[:notional_value].to_d * 100,
                               notional_value_currency: row[:currency],
                               unit_price_cents: row[:price].present? ? row[:price].to_d * 100 : 0,
                               unit_price_currency: row[:currency],
                               market_price_cents: (row[:market_price] || row[:market_value]).to_d * 100,
                               market_price_currency: row[:market_currency])
          when Holdings::BondPrice
            asset_price.update
          end

          date = file.date
          price = asset.prices.build(date:)
          price.priceable = asset_price
          quantity = row[:shares].to_d
          fund.holdings.build(date:, quantity: quantity.zero? ? 1 : quantity, price:, accrual_date: row[:accrual_date])
        end
      end
    end
  end
end
