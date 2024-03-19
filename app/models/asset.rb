# frozen_string_literal: true

class Asset < ApplicationRecord
  class UnknownTypeError < StandardError; end

  has_one :identity, class_name: 'Assets::Identity', dependent: :destroy

  alias_attribute :asset_class, :type
  delegate :ticker, :isin, to: :identity
end
