# frozen_string_literal: true

require 'csv'

module Holdings
  module Files
    class CSV < Base
      def csv
        @csv ||= ::CSV.new rows, headers: true, converters: :numeric, header_converters: :symbol
      end

      def date
        @date ||= Date.parse(body.lines[1].split('"')[1])
      end

      private

      def rows
        (body.lines.drop(9) - body.lines.drop(9).slice(-12, 12)).join
      end
    end
  end
end
