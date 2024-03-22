# frozen_string_literal: true

module Holdings
  module Extraction
    class ExcelOpenStrategy < Strategy
      def extract(file)
        worksheet = file.workbook.worksheets.first

        Rover::DataFrame.new(worksheet.drop(5).map do |row|
          row.cells.reduce.with_index do |memo, index|
            case index
            when 0
              memo[:name] = cell.value
            when 1
              memo[:ticker] = cell.value
            when 2
              memo[:identifier] = cell.value
            when 3
              memo[:sedol] = cell.value
            when 4
              memo[:weight] = cell.value
            when 5
              memo[:sector] = cell.value
            when 6
              memo[:shares_held] = cell.value
            when 7
              memo[:local_currency] = cell.value
            end
          end
        end)
      end
    end
  end
end
