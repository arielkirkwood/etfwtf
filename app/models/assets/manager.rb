# frozen_string_literal: true

module Assets
  class Manager < ApplicationRecord
    has_many :funds, dependent: :destroy
  end
end
