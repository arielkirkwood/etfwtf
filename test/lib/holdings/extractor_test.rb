# frozen_string_literal: true

require 'test_helper'

class ExtractorTest < ActiveSupport::TestCase
  setup do
    @fund = funds(:crbn)
    @extractor = Holdings::Extractor.new(@fund)
    @portfolio = @extractor.portfolio
  end

  test 'initialize' do
    assert_equal @extractor.fund, @fund
    assert_not @portfolio.persisted?
  end

  test 'attach holdings file' do
    assert_not @portfolio.holdings_file.attached?

    VCR.use_cassette('ishares_holdings_file') do
      @extractor.attach_holdings_file
    end

    assert @portfolio.holdings_file.attached?
    assert_equal @portfolio.date, Time.zone.today
    assert_equal @portfolio, @fund.latest_portfolio
    assert_equal @fund.portfolios.count, 1
  end
end
