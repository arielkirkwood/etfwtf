# frozen_string_literal: true

module Markets
  class Exchange < ApplicationRecord
    validates :name, length: { minimum: 2 }
  end
end
