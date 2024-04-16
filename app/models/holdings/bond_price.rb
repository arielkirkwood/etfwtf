# frozen_string_literal: true

module Holdings
  class BondPrice < ApplicationRecord
    has_one :holding, as: :priceable, dependent: :destroy

    monetize :par_value_cents

    validates :maturity_date, timeliness: { type: :date }, allow_nil: true
  end
end
