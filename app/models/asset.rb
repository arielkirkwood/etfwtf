# frozen_string_literal: true

class Asset < ApplicationRecord
  alias_attribute :asset_class, :type
end
