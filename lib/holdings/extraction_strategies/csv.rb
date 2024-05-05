# frozen_string_literal: true

require 'csv'

module Holdings
  module ExtractionStrategies
    class CSV < Base
      def holdings_count
        @holdings_count ||= set_holdings_count
      end

      private

      def csv
        @csv ||= ::CSV.new csv_string, encoding: Encoding.default_external,
                                       headers: true, converters: :numeric, header_converters: :symbol
      end

      def csv_string
        rows.join
      end

      def rows
        @rows ||= (body.lines.drop(self.class::ROWS_TO_DROP) - body.lines.drop(self.class::ROWS_TO_DROP).slice(-self.class::ROWS_TO_SLICE, self.class::ROWS_TO_SLICE))
      end
    end
  end
end
