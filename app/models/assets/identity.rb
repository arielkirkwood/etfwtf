# frozen_string_literal: true

module Assets
  class Identity < ApplicationRecord
    belongs_to :asset
    belongs_to :exchange, class_name: 'Assets::Exchange'

    validates :identifier, length: { minimum: 1 }, uniqueness: { scope: :exchange_id }
  end
end
