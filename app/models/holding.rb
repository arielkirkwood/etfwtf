# frozen_string_literal: true

class Holding < ApplicationRecord
  belongs_to :portfolio
  belongs_to :price, class_name: 'Holdings::Price'

  has_one :asset_price, through: :price, source: :priceable, source_type: 'Holdings::EquityPrice', class_name: 'Holdings::EquityPrice'

  delegate :asset, to: :price
  delegate :asset_class, :exchange, to: :asset

  validates :accrual_date, timeliness: { type: :date }, allow_nil: true
  validates :quantity, numericality: true
  validates :price, uniqueness: { scope: [:portfolio, :quantity] }
end
