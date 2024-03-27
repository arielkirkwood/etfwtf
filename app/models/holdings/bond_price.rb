# frozen_string_literal: true

module Holdings
  class BondPrice < ApplicationRecord
    has_one :price, as: :priceable, dependent: :destroy
    has_one :asset, through: :price

    monetize :par_value_cents
  end
end
