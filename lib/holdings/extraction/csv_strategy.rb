# frozen_string_literal: true

module Holdings
  module Extraction
    class CSVStrategy < Strategy
      def extract(file)
        Holding.transaction do
          file.csv.map do |row|
            asset = Asset.find_or_create_by!(type: asset_type(row[:asset_class]), ticker: row[:ticker], name: row[:name], sector: row[:sector])

            fund.holdings.build(asset:,
                                date: file.date,
                                quantity: row[:shares],
                                price: row[:price],
                                market_price: row[:market_price])
          end
        end
      end

      private

      def asset_type(asset_class)
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
