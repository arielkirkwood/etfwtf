# frozen_string_literal: true

require 'rubyXL'

module Holdings
  module ExtractionStrategies
    class Excel < Base
      def holdings_count
        @holdings_count ||= working_sheet.count
      end

      private

      def working_sheet
        worksheet.drop(self.class::ROWS_TO_DROP).map do |rubyxl_row|
          Hash[*self.class::HEADINGS.zip(rubyxl_row.cells.map { |cell| cell.respond_to?(:value) ? cell.value : nil }).flatten]
        end
      end

      def worksheet
        @worksheet ||= workbook.worksheets.first
      end

      def workbook
        @workbook ||= RubyXL::Parser.parse_buffer(body)
      rescue ::Zip::Error => e
        raise e, "XLSX file format error: #{e}", e.backtrace
      end
    end
  end
end
