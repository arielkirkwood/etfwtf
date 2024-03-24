# frozen_string_literal: true

require 'rubyXL'

module Holdings
  class ExcelOpenXMLFile < Mechanize::File
    attr_reader :date, :workbook

    def initialize(uri, response = nil, body = nil, code = nil)
      super(uri, response, body, code)

      @date = Date.parse(@workbook[0][2][1].value.split('As of ').last)
      @workbook = RubyXL::Parser.parse_buffer(body)
    rescue ::Zip::Error => e
      raise e, "XLSX file format error: #{e}", e.backtrace
    end
  end
end
