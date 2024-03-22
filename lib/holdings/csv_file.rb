# frozen_string_literal: true

require 'csv'

module Holdings
  class CSVFile < Mechanize::File
    attr_reader :date, :csv

    def initialize(uri, response = nil, body = nil, code = nil)
      super(uri, response, body, code)

      @date = Date.parse(body.lines[1].split('"')[1])
      @csv = CSV.new rows(body),
                     headers: true,
                     converters: :numeric,
                     header_converters: :symbol
    end

    private

    def rows(body)
      (body.lines.drop(9) - body.lines.drop(9).slice(-12, 12)).join
    end
  end
end
