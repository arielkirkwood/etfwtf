# frozen_string_literal: true

require 'test_helper'

class InitialExtractorTest < ActiveSupport::TestCase
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
    assert_equal @portfolio.holdings_file.attachments.first.blob.filename, 'CRBN_holdings.csv'
    assert_equal @portfolio.date, Time.zone.today
    assert_equal @portfolio, @fund.latest_portfolio
    assert_equal @fund.portfolios.count, 1
  end

  test 'extract holdings' do
    WebMock
      .stub_request(:get, 'https://www.ishares.com/us/products/271054/ishares-msci-acwi-low-carbon-target-etf/1467271812596.ajax?dataType=fund&fileName=CRBN_holdings&fileType=csv')
      .to_return(
        status: 200,
        body: Rails.root.join('test/fixtures/files/CRBN_holdings.csv').read,
        headers: {
          content_type: 'text/csv;charset=UTF-8',
          content_disposition: 'attachment; filename=CRBN_holdings.csv'
        }
      )

    @extractor.attach_holdings_file
    assert_equal @portfolio.holdings_file.attachments.first.blob.filename, 'CRBN_holdings.csv'
    @extractor.extract_holdings

    assert_equal @portfolio.date, Date.parse('06 Jun 2024')
    assert_equal @portfolio.holdings.count, 7
  end
end
