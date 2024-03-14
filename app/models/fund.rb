class Fund < ApplicationRecord
  has_many :holdings
  has_many :assets, through: :holdings
  # has_many :equities
end
