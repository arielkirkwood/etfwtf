# frozen_string_literal: true

module Assets
  class Ticker < Identity
    alias_attribute :ticker, :identifier
  end
end
