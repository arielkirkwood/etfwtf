# frozen_string_literal: true

module Assets
  class Identity < ApplicationRecord
    belongs_to :asset

    alias_attribute :ticker, :identifier
  end
end
