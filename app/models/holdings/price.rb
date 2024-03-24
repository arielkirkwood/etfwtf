# frozen_string_literal: true

module Holdings
  class Price < ApplicationRecord
    belongs_to :asset

    monetize :market_price_cents, :notional_value_cents, :unit_price_cents
  end
end
