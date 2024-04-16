# frozen_string_literal: true

class Holding < ApplicationRecord
  belongs_to :asset
  belongs_to :portfolio
  belongs_to :priceable, polymorphic: true

  has_one :exchange, through: :asset

  monetize :notional_value_cents, :market_value_cents

  validates :accrual_date, timeliness: { type: :date }, allow_nil: true
  validates :asset, uniqueness: { scope: [:portfolio, :priceable_id] }
  validates :date, timeliness: { type: :date }
  validates :quantity, numericality: true
  validates_associated :priceable

  delegate :asset_class, to: :asset
end
