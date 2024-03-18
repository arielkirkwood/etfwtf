# frozen_string_literal: true

module Holdings
  module Extraction
    class Strategy
      attr_accessor :fund

      def initialize(fund)
        @fund = fund
      end
    end
  end
end
