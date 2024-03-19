# frozen_string_literal: true

class Holding < ApplicationRecord
  belongs_to :asset
  belongs_to :fund

  monetize :notional_value_cents
  monetize :unit_price_cents
  monetize :market_price_cents
end
