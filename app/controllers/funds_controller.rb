# frozen_string_literal: true

class FundsController < ApplicationController
  def index
    @funds = Fund.includes(:underlying_asset, :ticker).where(manager_id: 1)
  end

  def show
    @ticker = Assets::Ticker.find_by(ticker: params[:ticker].upcase)
    @fund = @ticker.asset.fund
  end
end
