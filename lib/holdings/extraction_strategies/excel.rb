# frozen_string_literal: true

module Holdings
  module ExtractionStrategies
    class Excel < Base
      def extract(file) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        worksheet = file.workbook.worksheets.first
        date = file.date

        headings = [:name, :ticker, :identifier, :sedol, :weight, :sector, :shares_held, :local_currency]
        data = worksheet.drop(5).map { |row| headings.zip(row.cells.map(&:value)).to_h }

        data.map do |row|
          asset = Asset.find_by(identity: Assets::Identity.find_by(identifier: row[:ticker]))

          if asset.blank?
            asset = Asset.find_or_create_by!(name: row[:name], sector: row[:sector])
            Assets::Ticker.create(asset:, identifier: row[:ticker])
          end

          price = asset.prices.find_by!(date:) if asset.prices.any?

          # notional_value_cents = row[:notional_value].to_d * 100
          # unit_price_cents = row[:price].present? ? row[:price].to_d * 100 : 0
          # market_price_cents = (row[:market_price] || row[:market_value]).to_d * 100

          holding = fund.holdings.build(asset:,
                                        date:,
                                        quantity: row[:shares_held])

          holding.price = price if price
          holding
        end
      end
    end
  end
end
