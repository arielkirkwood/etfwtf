# frozen_string_literal: true

module Assets
  class Identity < ApplicationRecord
    belongs_to :asset
  end
end
