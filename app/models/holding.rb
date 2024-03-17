class Holding < ApplicationRecord
  belongs_to :asset
  belongs_to :fund

  monetize :market_price_cents
  monetize :price_cents
end
