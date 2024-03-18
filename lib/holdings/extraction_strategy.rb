# frozen_string_literal: true

module Holdings
  class ExtractionStrategy
    attr_accessor :fund, :file

    def initialize(fund, file)
      @fund = fund
      @file = file
    end
  end
end
