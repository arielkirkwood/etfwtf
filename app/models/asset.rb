# frozen_string_literal: true

class Asset < ApplicationRecord
  class UnknownTypeError < StandardError; end

  belongs_to :exchange, # rubocop:disable Rails/InverseOf
             class_name: 'Markets::Exchange',
             foreign_key: :market_identification_code,
             primary_key: :market_identification_code,
             optional: true

  has_one :isin, class_name: 'Assets::ISIN', dependent: :destroy
  has_one :ticker, class_name: 'Assets::Ticker', dependent: :destroy

  has_many :identities, class_name: 'Assets::Identity', dependent: :destroy
  has_many :holdings, dependent: :nullify
  has_many :prices, through: :holdings, source: :priceable, source_type: 'Holdings::EquityPrice', class_name: 'Holdings::EquityPrice', dependent: :destroy

  validates :sector, length: { minimum: 2 }, allow_nil: true
  validates_associated :identities

  alias_attribute :asset_class, :type
end
