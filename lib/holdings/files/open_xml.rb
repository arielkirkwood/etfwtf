# frozen_string_literal: true

require 'rubyXL'

module Holdings
  module Files
    class OpenXML < Base
      def workbook
        @workbook ||= RubyXL::Parser.parse_buffer(body)
      rescue ::Zip::Error => e
        raise e, "XLSX file format error: #{e}", e.backtrace
      end

      def date
        @date ||= Date.parse(workbook[0][2][1].value.split('As of ').last)
      end
    end
  end
end
