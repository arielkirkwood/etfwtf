# frozen_string_literal: true

module Holdings
  class EquityPrice < ApplicationRecord
    has_one :price, as: :priceable, dependent: :destroy
    has_one :asset, through: :price

    monetize :market_price_cents, :notional_value_cents, :unit_price_cents
  end
end
