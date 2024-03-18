# frozen_string_literal: true

class Asset < ApplicationRecord
  class UnknownTypeError < StandardError; end

  alias_attribute :asset_class, :type
end
