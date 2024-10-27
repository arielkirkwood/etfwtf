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
    assert_not @portfolio.persisted?, 'Portfolio should not be persisted'
  end

  test 'attach holdings file' do
    assert_not @portfolio.holdings_file.attached?

    VCR.use_cassette('ishares_holdings_file') do
      @extractor.attach_holdings_file
    end

    assert @portfolio.persisted?, 'Portfolio should be saved'
    assert_equal @fund.portfolios.count, 1

    assert @portfolio.holdings_file.attached?
    assert_equal @portfolio.holdings_file.attachments.first.blob.filename, 'CRBN_holdings.csv'
    assert_equal @portfolio.date, Time.zone.today
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

class SubsequentExtractorTest < ActiveSupport::TestCase
  setup do
    @fund = funds(:crbn)
    @portfolio = @fund.portfolios.create!(date: Date.parse('06 Jun 2024'))
    asset = assets(:brkb)
    priceable = asset.prices.build
    @portfolio.holdings.create!(
      date: @portfolio.date,
      asset:,
      priceable:,
      quantity: 1,
      notional_value_cents: 0,
      market_value_cents: 0
    )
    VCR.use_cassette('xnys_exchange_status_weekend') do
      @extractor = Holdings::Extractor.new(@fund)
    end
  end

  test 'initialize' do
    assert @extractor.portfolio.persisted?, 'Portfolio should be persisted and not new'
  end
end
