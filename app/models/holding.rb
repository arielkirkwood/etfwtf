class Holding < ApplicationRecord
  belongs_to :fund

  has_many :assets, through: :assets_holdings
end
