# frozen_string_literal: true

class Fund < ApplicationRecord
  belongs_to :manager, class_name: 'Assets::Manager'
  belongs_to :underlying_asset, class_name: 'Asset', inverse_of: :fund

  has_one :latest_portfolio, -> { order date: :desc }, class_name: 'Portfolio', inverse_of: :fund, dependent: :destroy
  has_one :exchange, through: :underlying_asset
  has_one :ticker, through: :underlying_asset, class_name: 'Assets::Ticker'

  has_many :identities, through: :underlying_asset, class_name: 'Assets::Identity'
  has_many :portfolios, dependent: :destroy
  has_many :holdings, through: :portfolios
  has_many :assets, through: :holdings

  delegate :extract_holdings, to: :holdings_extractor
  delegate :name, :type, :sector, to: :underlying_asset

  validates :underlying_asset_id, uniqueness: true

  def exchange_status
    @exchange_status ||= reload_exchange_status
  end

  def to_param
    ticker.identifier.downcase
  end

  private

  def reload_exchange_status
    # aliasing certain problematic markets
    target_exchange = problem?(exchange.mic) ? Markets::Exchange.find(solution(exchange.mic)) : exchange

    candidate_status = Markets::API::Status.for_exchange(target_exchange.operating_exchange).fetch.first
    @exchange_status = candidate_status.presence || Markets::API::Status.for_exchange(target_exchange).fetch.first
  end

  def problem?(mic)
    mic.in?(Markets::API::Status::MISSING_MICS.keys)
  end

  def solution(mic)
    Markets::API::Status::MISSING_MICS[mic]
  end

  def holdings_extractor
    @holdings_extractor ||= Holdings::Extractor.new(self)
  end
end
