# frozen_string_literal: true

module Assets
  class Ticker < Identity
    belongs_to :exchange, class_name: 'Assets::Exchange'

    alias_attribute :ticker, :identifier
  end
end
