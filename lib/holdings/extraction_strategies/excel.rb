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
          ticker = Assets::Ticker.find_or_create_by(ticker: row[:ticker])
          # cusip = Assets::CUSIP.find_or_create_by(cusip: row[:identifier])
          # sedol = Assets::SEDOL.find_or_create_by(sedol: row[:sedol])
          asset = Asset.find_by(ticker:)

          if asset.blank?
            asset = Asset.find_or_create_by!(name: row[:name], sector: row[:sector])
            Assets::Ticker.create(asset:, identifier: row[:ticker])
          end

          price = if asset.prices.any?
                    asset.prices.find_by(date:)
                  else
                    asset.prices.create(date:)
                  end

          fund.holdings.build(date:, quantity: row[:shares_held], price:)
        end
      end
    end
  end
end
