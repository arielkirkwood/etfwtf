class Holding < ApplicationRecord
  belongs_to :fund
  has_one :asset
end
