# frozen_string_literal: true

class Fund < ApplicationRecord
  belongs_to :manager, class_name: 'Assets::Manager'
  belongs_to :underlying_asset, class_name: 'Asset'

  has_one :portfolio, dependent: :destroy

  has_many :holdings, through: :portfolio
  has_many :assets, through: :holdings

  delegate :extract_holdings, to: :holdings_extractor
  delegate :name, to: :underlying_asset

  validates :underlying_asset_id, uniqueness: true

  private

  def holdings_extractor
    @holdings_extractor ||= Holdings::Extractor.new(self)
  end
end
