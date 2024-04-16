# frozen_string_literal: true

require 'rubyXL'

module Holdings
  module ExtractionStrategies
    class Excel < Base
      HEADINGS = [:name, :ticker, :identifier, :sedol, :weight, :sector, :shares_held, :local_currency].freeze

      def date
        @date ||= Date.parse(workbook[0][2][1].value.split('As of ').last)
      rescue DateError
        @date = Date.parse(workbook[0][1][1].value)
      end

      def holdings_count; end

      def extract_holdings # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        rows.map do |row|
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

      def rows
        @rows ||= worksheet.drop(5).map { |row| HEADINGS.zip(row.cells.map(&:value)).to_h }
      end

      def worksheet
        @worksheet ||= workbook.worksheets.first
      end

      def workbook
        @workbook ||= RubyXL::Parser.parse(portfolio.holdings_file)
      rescue ::Zip::Error => e
        raise e, "XLSX file format error: #{e}", e.backtrace
      end
    end
  end
end
