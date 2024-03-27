# frozen_string_literal: true

class Holding < ApplicationRecord
  belongs_to :fund
  belongs_to :price, class_name: 'Holdings::Price'

  has_one :asset_price, through: :price, source: :priceable, source_type: 'Holdings::EquityPrice', class_name: 'Holdings::EquityPrice'

  delegate :asset, to: :price
  delegate :asset_class, :exchange, to: :asset

  validates :quantity, numericality: true
  validates :price, uniqueness: { scope: [:fund, :quantity, :date] }
end
