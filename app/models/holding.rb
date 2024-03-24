# frozen_string_literal: true

class Holding < ApplicationRecord
  belongs_to :fund
  belongs_to :price, class_name: 'Holdings::Price'

  delegate :asset, :market_price, :notional_value, :unit_price, to: :price
end
