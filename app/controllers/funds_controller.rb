# frozen_string_literal: true

class FundsController < ApplicationController
  def index
    @funds = Assets::Manager.where(name: 'iShares').first.funds.includes(:underlying_asset).first(2)
  end
end
