# frozen_string_literal: true

class Fund < ApplicationRecord
  belongs_to :manager, class_name: 'Assets::Manager'
  belongs_to :underlying_asset, class_name: 'Asset'

  has_many :holdings, dependent: :destroy
  has_many :assets, through: :holdings

  def holdings_extractor
    @holdings_extractor ||= Holdings::Extractor.new(self)
  end
end
