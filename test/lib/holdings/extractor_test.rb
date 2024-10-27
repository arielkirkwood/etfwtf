# frozen_string_literal: true

require 'test_helper'

class ExtractorTest < ActiveSupport::TestCase
  setup do
    @fund = funds(:crbn)
    @extractor = Holdings::Extractor.new(@fund)
  end

  test 'initialize' do
    assert_equal @extractor.fund, @fund
    assert_equal @extractor.portfolio, @fund.latest_portfolio
    assert_equal @fund.portfolios.count, 1
  end
end
