class Fund < ApplicationRecord
  has_many :assets
  has_many :equities
end
