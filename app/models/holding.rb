# frozen_string_literal: true

class Holding < ApplicationRecord
  belongs_to :fund
  belongs_to :price, class_name: 'Holdings::Price'

  delegate :asset, :market_price, :notional_value, :unit_price, to: :price
  delegate :exchange, to: :asset

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :price, uniqueness: { scope: [:fund, :quantity, :date] }
end
