# frozen_string_literal: true

module Holdings
  class EquityPrice < ApplicationRecord
    has_one :holding, as: :priceable, dependent: :destroy

    monetize :price_cents
  end
end
