# frozen_string_literal: true

module Holdings
  class BondPrice < ApplicationRecord
    has_one :holding, as: :priceable, dependent: :destroy
    has_one :asset, through: :holding

    monetize :par_value_cents

    validates :maturity_date, timeliness: { type: :date }
  end
end
