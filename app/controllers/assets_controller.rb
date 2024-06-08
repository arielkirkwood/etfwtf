# frozen_string_literal: true

class AssetsController < ApplicationController
  def show
    @ticker = Assets::Ticker.find_by(ticker: params[:ticker].upcase)
    @asset = @ticker.asset
  end
end
