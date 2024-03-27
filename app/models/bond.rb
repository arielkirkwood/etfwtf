# frozen_string_literal: true

class Bond < Asset
  has_many :asset_prices, through: :prices, source: :priceable, source_type: 'Holdings::BondPrice', class_name: 'Holdings::BondPrice', dependent: :destroy
end
