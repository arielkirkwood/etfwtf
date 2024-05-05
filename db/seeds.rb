# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'csv'
require 'mechanize'

MARKET_EXCHANGES_FILENAME = 'ISO10383_MIC.csv'

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
Fund.find_or_create_by!(
  underlying_asset: crbn_asset, manager: ishares, public_url: 'https://www.ishares.com/us/products/271054/',
  betterment_detail: 'CRBN is the primary ETF used to gain exposure to global green stocks. CRBN gives exposure to a diversified investment in global stocks that is less dependent on fossil ' \
                     'fuels than the broader market, by investing more in companies with low carbon emissions and less in companies with a high carbon footprint.'
)
Fund.find_or_create_by!(
  underlying_asset: bgrn_asset, manager: ishares, public_url: 'https://www.ishares.com/us/products/305296/',
  betterment_detail: 'BGRN is the primary ETF used to gain exposure to global green bonds. The green bonds held by BGRN fund projects supporting alternative energy, energy efficiency, pollution ' \
                     'prevention and control, sustainable water, green building, and climate adaptation.'
)
Fund.find_or_create_by!(
  underlying_asset: stip_asset, manager: ishares, public_url: 'https://www.ishares.com/us/products/239450/',
  betterment_detail: 'STIP is the selected ETF used to gain exposure to U.S. Inflation-Protected Bonds due to its competitive bid-ask spread, low expense ratio, and robust asset base.'
)
Fund.find_or_create_by!(
  underlying_asset: emb_asset, manager: ishares, public_url: 'https://www.ishares.com/us/products/239572/',
  betterment_detail: 'EMB is the primary ETF used to gain exposure to International Emerging Market Bonds, due to its low expense ratio, tight bid-ask spread, and high level of market liquidity.'
)

Fund.find_or_create_by!(
  underlying_asset: vote_asset, manager: tcw, public_url: 'https://etf.tcw.com/vote/',
  betterment_detail: 'This set of holdings offers exposure to U.S. large-cap stocks. The fund issuer leverages the underlying holdings shareholder rights to promote better social and climate ' \
                     'focused corporate behavior.'
)

Fund.find_or_create_by!(
  underlying_asset: spyx_asset, manager: state_street, public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-sp-500-fossil-fuel-reserves-free-etf-spyx',
  betterment_detail: 'SPYX is the primary ETF used to gain exposure to fossil fuel reserves free stocks in U.S. markets.'
)
Fund.find_or_create_by!(
  underlying_asset: efax_asset, manager: state_street, public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-msci-eafe-fossil-fuel-reserves-free-etf-efax',
  betterment_detail: 'EFAX is the primary ETF used to gain exposure to fossil fuel reserves free stocks in international developed markets.'
)
Fund.find_or_create_by!(
  underlying_asset: eemx_asset, manager: state_street, public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-msci-emerging-markets-fossil-fuel-reserves-free-etf-eemx',
  betterment_detail: 'EEMX is the primary ETF used to gain exposure to fossil fuel reserve free stocks in emerging markets.'
)

# Non-fund asset seeds to help with first-time ingestion
berkshire_hathaway = Equity.find_or_create_by!(name: 'BERKSHIRE HATHAWAY INC CL B', sector: 'Financials', exchange: nasdaq)
Assets::Ticker.find_or_create_by!(ticker: 'BRK.B', asset: berkshire_hathaway)
Assets::Ticker.find_or_create_by!(ticker: 'BRKB', asset: berkshire_hathaway)
Assets::Ticker.find_or_create_by!(ticker: 'BRK/B', asset: berkshire_hathaway)
Assets::CUSIP.find_or_create_by!(cusip: '084670702', asset: berkshire_hathaway)
Assets::SEDOL.find_or_create_by!(sedol: '2073390', asset: berkshire_hathaway)
