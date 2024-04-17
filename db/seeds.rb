# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'csv'
require 'mechanize'

MARKET_EXCHANGES_FILENAME = 'ISO10383_MIC.csv'

Rails.logger = Logger.new($stdout)

agent = Mechanize.new do |config|
  config.user_agent_alias = 'iPhone'
  config.pluggable_parser.default = Mechanize::Download
end

# Exchanges
agent.download('https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC.csv', MARKET_EXCHANGES_FILENAME) unless File.exist?(MARKET_EXCHANGES_FILENAME)
exchanges = CSV.table(MARKET_EXCHANGES_FILENAME)

exchanges.each do |row|
  Markets::Exchange.find_or_create_by!(
    market_identification_code: row[:mic],
    operating_market_identification_code: row[:operating_mic],
    name: row[:market_nameinstitution_description],
    legal_entity_name: row[:legal_entity_name].presence,
    country: row[:iso_country_code_iso_3166], # rubocop:disable Naming/VariableNumber
    status: row[:status]
  )
end

nyse_arca = Markets::Exchange.iterated_search('NYSE ARCA').first
nasdaq = Markets::Exchange.iterated_search('NASDAQ').first
cboe = Markets::Exchange.iterated_search('Cboe BZX formerly known as BATS').first

# Managers
ishares = Assets::Manager.find_or_create_by!(name: 'iShares', holdings_link_text: 'Download Holdings', backup_holdings_link_text: 'Detailed Holdings and Analytics')
tcw = Assets::Manager.find_or_create_by!(name: 'TCW', holdings_link_text: 'Download')
state_street = Assets::Manager.find_or_create_by!(name: 'State Street', holdings_link_text: 'Daily')

# Assets
crbn_asset = Asset.find_or_create_by!(name: 'iShares MSCI ACWI Low Carbon Target ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Global Large-Stock Blend',
                                      exchange: nyse_arca)
bgrn_asset = Asset.find_or_create_by!(name: 'iShares USD Green Bond ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Global Bond-USD Hedged',
                                      exchange: nyse_arca)
ivv_asset = Asset.find_or_create_by!(name: 'iShares Core S&P 500 ETF',
                                     type: 'ExchangeTradedFund',
                                     sector: 'Large Blend',
                                     exchange: nyse_arca)
stip_asset = Asset.find_or_create_by!(name: 'iShares 0-5 Year TIPS Bond ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Inflation-Protected Bond',
                                      exchange: nyse_arca)
emb_asset = Asset.find_or_create_by!(name: 'iShares J.P. Morgan USD Emerging Markets Bond ETF',
                                     type: 'ExchangeTradedFund',
                                     sector: 'Emerging Markets Bond',
                                     exchange: nasdaq)

vote_asset = Asset.find_or_create_by!(name: 'TCW Transform 500 ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Large Blend',
                                      exchange: cboe)

spyx_asset = Asset.find_or_create_by!(name: 'SPDR® S&P® 500 Fossil Fuel Reserves Free ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Large Blend',
                                      exchange: nyse_arca)
efax_asset = Asset.find_or_create_by!(name: 'SPDR® MSCI EAFE Fossil Fuel Reserves Free ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Foreign Large Blend',
                                      exchange: nyse_arca)
eemx_asset = Asset.find_or_create_by!(name: 'SPDR® MSCI Emerging Markets Fossil Fuel Reserves Free ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Diversified Emerging Markets',
                                      exchange: nyse_arca)

# Tickers & identifiers
Assets::Ticker.find_or_create_by!(asset: crbn_asset, ticker: 'CRBN')
Assets::Ticker.find_or_create_by!(asset: bgrn_asset, ticker: 'BGRN')
Assets::Ticker.find_or_create_by!(asset: ivv_asset, ticker: 'IVV')
Assets::Ticker.find_or_create_by!(asset: stip_asset, ticker: 'STIP')
Assets::Ticker.find_or_create_by!(asset: emb_asset, ticker: 'EMB')
Assets::Ticker.find_or_create_by!(asset: vote_asset, ticker: 'VOTE')

Assets::Ticker.find_or_create_by!(asset: spyx_asset, ticker: 'SPYX')
Assets::ISIN.find_or_create_by!(asset: spyx_asset, isin: 'US78468R7961')

Assets::Ticker.find_or_create_by!(asset: efax_asset, ticker: 'EFAX')
Assets::ISIN.find_or_create_by!(asset: efax_asset, isin: 'US78470E1064')

Assets::Ticker.find_or_create_by!(asset: eemx_asset, ticker: 'EEMX')
Assets::ISIN.find_or_create_by!(asset: eemx_asset, isin: 'US78470E2054')

# Funds
Fund.find_or_create_by!(underlying_asset: crbn_asset, manager: ishares, public_url: 'https://www.ishares.com/us/products/271054/')
Fund.find_or_create_by!(underlying_asset: bgrn_asset, manager: ishares, public_url: 'https://www.ishares.com/us/products/305296/')
Fund.find_or_create_by!(underlying_asset: ivv_asset, manager: ishares, public_url: 'https://www.ishares.com/us/products/239726/')
Fund.find_or_create_by!(underlying_asset: stip_asset, manager: ishares, public_url: 'https://www.ishares.com/us/products/239450/')
Fund.find_or_create_by!(underlying_asset: emb_asset, manager: ishares, public_url: 'https://www.ishares.com/us/products/239572/')

Fund.find_or_create_by!(underlying_asset: vote_asset, manager: tcw, public_url: 'https://etf.tcw.com/vote/')

Fund.find_or_create_by!(underlying_asset: spyx_asset, manager: state_street, public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-sp-500-fossil-fuel-reserves-free-etf-spyx')
Fund.find_or_create_by!(underlying_asset: efax_asset, manager: state_street, public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-msci-eafe-fossil-fuel-reserves-free-etf-efax')
Fund.find_or_create_by!(underlying_asset: eemx_asset, manager: state_street, public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-msci-emerging-markets-fossil-fuel-reserves-free-etf-eemx')

# Non-fund asset seeds to help with first-time ingestion
berkshire_hathaway = Equity.find_or_create_by!(name: 'BERKSHIRE HATHAWAY INC CL B', sector: 'Financials', exchange: nasdaq)
Assets::Ticker.find_or_create_by!(ticker: 'BRK.B', asset: berkshire_hathaway)
Assets::Ticker.find_or_create_by!(ticker: 'BRKB', asset: berkshire_hathaway)
Assets::Ticker.find_or_create_by!(ticker: 'BRK/B', asset: berkshire_hathaway)
Assets::CUSIP.find_or_create_by!(cusip: '084670702', asset: berkshire_hathaway)
Assets::SEDOL.find_or_create_by!(sedol: '2073390', asset: berkshire_hathaway)
