# frozen_string_literal: true

module Assets
  class Exchange < ApplicationRecord
    validates :name, uniqueness: true, length: { minimum: 2 }
  end
end
