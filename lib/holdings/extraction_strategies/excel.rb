# frozen_string_literal: true

require 'rubyXL'

module Holdings
  module ExtractionStrategies
    class Excel < Base
      def extract # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        worksheet = workbook.worksheets.first

        headings = [:name, :ticker, :identifier, :sedol, :weight, :sector, :shares_held, :local_currency]
        data = worksheet.drop(5).map { |row| headings.zip(row.cells.map(&:value)).to_h }

        data.map do |row|
          ticker = Assets::Ticker.find_or_create_by(ticker: row[:ticker])
          cusip = Assets::CUSIP.find_or_create_by(cusip: row[:identifier])
          sedol = Assets::SEDOL.find_or_create_by(sedol: row[:sedol])
          asset = Asset.find_or_create_by!(ticker:, cusip:, sedol:, name: row[:name], sector: row[:sector])

          price = if asset.prices.any?
                    asset.prices.find_by(date:)
                  else
                    asset.prices.create(date:)
                  end

          portfolio.holdings.build(date:, quantity: row[:shares_held], price:)
        end
      end

      private

      def workbook
        @workbook ||= RubyXL::Parser.parse(portfolio.holdings_file)
      rescue ::Zip::Error => e
        raise e, "XLSX file format error: #{e}", e.backtrace
      end

      def date
        @date ||= Date.parse(workbook[0][2][1].value.split('As of ').last)
      rescue DateError
        @date = Date.parse(workbook[0][1][1].value)
      end
    end
  end
end
