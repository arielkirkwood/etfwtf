# frozen_string_literal: true

module Holdings
  class ExtractionStrategy
    attr_accessor :fund

    def initialize(fund)
      @fund = fund
    end
  end
end
