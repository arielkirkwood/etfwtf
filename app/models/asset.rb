# frozen_string_literal: true

class Asset < ApplicationRecord
  class UnknownTypeError < StandardError; end

  has_many :identities, class_name: 'Assets::Identity', dependent: :destroy
  has_many :exchanges, through: :identities
  has_many :prices, class_name: 'Holdings::Price', dependent: :destroy
  has_many :asset_prices, through: :prices, source: :priceable, source_type: 'Holdings::EquityPrice', class_name: 'Holdings::EquityPrice', dependent: :destroy

  validates :sector, length: { minimum: 2 }, allow_nil: true

  alias_attribute :asset_class, :type
  # delegate :ticker, :isin, to: :identity
end
