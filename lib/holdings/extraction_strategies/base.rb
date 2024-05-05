# frozen_string_literal: true

module Holdings
  module ExtractionStrategies
    class Base
      ROWS_TO_DROP = 0
      ROWS_TO_SLICE = 0

      attr_reader :portfolio

      def initialize(portfolio)
        @portfolio = portfolio
      end

      private

      def body
        @body ||= portfolio.holdings_file.open(&:read)
      end
    end
  end
end
