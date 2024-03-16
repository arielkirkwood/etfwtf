class Fund < ApplicationRecord
  belongs_to :manager, class_name: 'Assets::Manager'
  belongs_to :underlying_asset, class_name: 'Asset'

  has_many :holdings
  has_many :assets, through: :holdings
  # has_many :equities
end
