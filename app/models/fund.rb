# frozen_string_literal: true

class Fund < ApplicationRecord
  belongs_to :manager, class_name: 'Assets::Manager'
  belongs_to :underlying_asset, class_name: 'Asset'

  has_many :portfolios, dependent: :destroy
  has_one :exchange, through: :underlying_asset

  has_many :holdings, through: :portfolio
  has_many :assets, through: :holdings

  delegate :extract_holdings, to: :holdings_extractor
  delegate :name, to: :underlying_asset

  validates :underlying_asset_id, uniqueness: true

  def exchange_status
    @exchange_status ||= reload_exchange_status
  end

  private

  def reload_exchange_status
    @exchange_status = Markets::API::Status.for_exchange(exchange.operating_exchange).fetch.first
  end

  def holdings_extractor
    @holdings_extractor ||= Holdings::Extractor.new(self)
  end
end
