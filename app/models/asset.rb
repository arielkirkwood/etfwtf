# frozen_string_literal: true

class Asset < ApplicationRecord
  class UnknownTypeError < StandardError; end

  belongs_to :exchange, # rubocop:disable Rails/InverseOf
             class_name: 'Markets::Exchange',
             foreign_key: :market_identification_code,
             primary_key: :market_identification_code,
             optional: true

  has_one :cusip, class_name: 'Assets::CUSIP', dependent: :destroy
  has_one :isin, class_name: 'Assets::ISIN', dependent: :destroy
  has_one :sedol, class_name: 'Assets::SEDOL', dependent: :destroy
  has_one :ticker, class_name: 'Assets::Ticker', dependent: :destroy
  has_one :fund, foreign_key: 'underlying_asset_id', dependent: :nullify, inverse_of: :underlying_asset

  has_many :identities, class_name: 'Assets::Identity', dependent: :destroy
  has_many :holdings, dependent: :nullify
  has_many :prices, through: :holdings, source: :priceable, source_type: 'Holdings::EquityPrice', class_name: 'Holdings::EquityPrice', dependent: :destroy

  validates :sector, length: { minimum: 2 }, allow_nil: true
  validates :name, uniqueness: { scope: [:type, :sector, :market_identification_code] }
  validates_associated :identities

  alias_attribute :asset_class, :type
end
