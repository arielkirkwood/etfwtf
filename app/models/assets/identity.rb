# frozen_string_literal: true

module Assets
  class Identity < ApplicationRecord
    belongs_to :asset

    validates :identifier, length: { minimum: 1 }, uniqueness: { scope: :asset_id }
  end
end
