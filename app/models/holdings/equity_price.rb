# frozen_string_literal: true

module Holdings
  class EquityPrice < ApplicationRecord
    has_one :holding, as: :priceable, dependent: :destroy
    has_one :asset, through: :holding

    monetize :price_cents
  end
end
