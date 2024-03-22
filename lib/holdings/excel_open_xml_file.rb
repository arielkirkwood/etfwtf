# frozen_string_literal: true

require 'rubyXL'

module Holdings
  class ExcelOpenXMLFile < Mechanize::File
    attr_reader :date, :workbook

    def initialize(uri, response = nil, body = nil, code = nil)
      super(uri, response, body, code)

      @date = Date.parse(self.response['last-modified'])
      @workbook = RubyXL::Parser.parse_buffer(body)
    rescue ::Zip::Error => e
      raise e, "XLSX file format error: #{e}", e.backtrace
    end

    private

    def rows(body)
      (body.lines.drop(9) - body.lines.drop(9).slice(-12, 12)).join
    end
  end
end
