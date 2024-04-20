# frozen_string_literal: true

class FundsController < ApplicationController
  def index
    @funds = Fund.includes(:underlying_asset, :ticker).where(manager_id: 1)
  end

  def show
    @fund = Fund.includes(:holdings).find_by(underlying_asset_id: Assets::Ticker.find_by(identifier: params[:ticker].upcase).asset_id)
  end
end
