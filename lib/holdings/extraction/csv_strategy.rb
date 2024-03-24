# frozen_string_literal: true

module Holdings
  module Extraction
    class CSVStrategy < Strategy
      def extract(file) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        file.csv.map do |row|
          asset = Asset.find_or_create_by!(type: asset_type(row[:asset_class]), name: row[:name], sector: row[:sector])

          if asset.identity.blank?
            if row[:ticker].present?
              if asset.is_a?(CashEquivalent) && row[:market_currency].present?
                Assets::CurrencyIdentity.find_or_create_by(asset:, identifier: row[:market_currency])
              else
                Assets::Ticker.find_or_create_by!(asset:, identifier: row[:ticker])
              end
            elsif row[:isin].present?
              Assets::ISINIdentity.find_or_create_by(asset:, identifier: row[:isin])
            end
          end

          date = file.date
          price = Holdings::Price.find_or_initialize_by(asset:, date:)
          price.update(notional_value_cents: row[:notional_value].to_d * 100,
                       notional_value_currency: row[:currency],
                       unit_price_cents: row[:price].present? ? row[:price].to_d * 100 : 0,
                       unit_price_currency: row[:currency],
                       market_price_cents: (row[:market_price] || row[:market_value]).to_d * 100,
                       market_price_currency: row[:market_currency])

          fund.holdings.build(date:, quantity: row[:shares].to_d, price:, accrual_date: row[:accrual_date])
        end
      end
    end
  end
end
