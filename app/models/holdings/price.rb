# frozen_string_literal: true

module Holdings
  class Price < ApplicationRecord
    belongs_to :asset
    belongs_to :priceable, polymorphic: true

    delegate :market_price, :notional_value, :unit_price, to: :priceable # Equity price attributes
    delegate :par_value, to: :priceable # Bond price attributes
  end
end
