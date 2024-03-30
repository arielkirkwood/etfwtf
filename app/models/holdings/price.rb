# frozen_string_literal: true

module Holdings
  class Price < ApplicationRecord
    belongs_to :asset
    belongs_to :priceable, polymorphic: true

    monetize :notional_value_cents, :market_value_cents
  end
end
