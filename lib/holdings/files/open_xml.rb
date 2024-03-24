# frozen_string_literal: true

require 'rubyXL'

module Holdings
  module Files
    class OpenXML < Mechanize::File
      def workbook
        @workbook ||= RubyXL::Parser.parse_buffer(body)
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
