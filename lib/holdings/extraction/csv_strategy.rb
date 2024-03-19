# frozen_string_literal: true

module Holdings
  module Extraction
    class CSVStrategy < Strategy
      def extract(file)
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
  end
end
