# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Rails.logger = Logger.new($stdout)

# Exchanges
nyse_arca = Markets::Exchange.find_or_create_by!(name: 'NYSE ARCA')
nasdaq = Markets::Exchange.find_or_create_by!(name: 'NASDAQ')
cboe = Markets::Exchange.find_or_create_by!(name: 'Cboe BZX formerly known as BATS')

# Managers
ishares = Assets::Manager.find_or_create_by!(name: 'iShares', holdings_link_text: 'Detailed Holdings and Analytics')
tcw = Assets::Manager.find_or_create_by!(name: 'TCW', holdings_link_text: 'Download')
state_street = Assets::Manager.find_or_create_by!(name: 'State Street', holdings_link_text: 'Daily')

# Assets
crbn_asset = Asset.find_or_create_by!(name: 'iShares MSCI ACWI Low Carbon Target ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Global Large-Stock Blend')
bgrn_asset = Asset.find_or_create_by!(name: 'iShares USD Green Bond ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Global Bond-USD Hedged')
ivv_asset = Asset.find_or_create_by!(name: 'iShares Core S&P 500 ETF',
                                     type: 'ExchangeTradedFund',
                                     sector: 'Large Blend')
stip_asset = Asset.find_or_create_by!(name: 'iShares 0-5 Year TIPS Bond ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Inflation-Protected Bond')
emb_asset = Asset.find_or_create_by!(name: 'iShares J.P. Morgan USD Emerging Markets Bond ETF',
                                     type: 'ExchangeTradedFund',
                                     sector: 'Emerging Markets Bond')

vote_asset = Asset.find_or_create_by!(name: 'TCW Transform 500 ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Large Blend')

spyx_asset = Asset.find_or_create_by!(name: 'SPDR® S&P® 500 Fossil Fuel Reserves Free ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Large Blend')
efax_asset = Asset.find_or_create_by!(name: 'SPDR® MSCI EAFE Fossil Fuel Reserves Free ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Foreign Large Blend')
eemx_asset = Asset.find_or_create_by!(name: 'SPDR® MSCI Emerging Markets Fossil Fuel Reserves Free ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Diversified Emerging Markets')

# Tickers & identifiers
Assets::Ticker.find_or_create_by!(asset: crbn_asset, ticker: 'CRBN', exchange: nyse_arca)
Assets::Ticker.find_or_create_by!(asset: bgrn_asset, ticker: 'BGRN', exchange: nyse_arca)
Assets::Ticker.find_or_create_by!(asset: ivv_asset, ticker: 'IVV', exchange: nyse_arca)
Assets::Ticker.find_or_create_by!(asset: stip_asset, ticker: 'STIP', exchange: nyse_arca)
Assets::Ticker.find_or_create_by!(asset: emb_asset, ticker: 'EMB', exchange: nasdaq)

Assets::Ticker.find_or_create_by!(asset: vote_asset, ticker: 'VOTE', exchange: cboe)

Assets::Ticker.find_or_create_by!(asset: spyx_asset, ticker: 'SPYX', exchange: nyse_arca)
Assets::ISIN.find_or_create_by!(asset: spyx_asset, isin: 'US78468R7961', exchange: nyse_arca)
Assets::Ticker.find_or_create_by!(asset: efax_asset, ticker: 'EFAX', exchange: nyse_arca)
Assets::ISIN.find_or_create_by!(asset: efax_asset, isin: 'US78470E1064', exchange: nyse_arca)
Assets::Ticker.find_or_create_by!(asset: eemx_asset, ticker: 'EEMX', exchange: nyse_arca)
Assets::ISIN.find_or_create_by!(asset: eemx_asset, isin: 'US78470E2054', exchange: nyse_arca)

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
berkshire_hathaway = Equity.find_or_create_by!(name: 'BERKSHIRE HATHAWAY INC CL B', sector: 'Financials')
Assets::Ticker.find_or_create_by!(ticker: 'BRK.B', asset: berkshire_hathaway, exchange: nasdaq)
Assets::Ticker.find_or_create_by!(ticker: 'BRKB', asset: berkshire_hathaway, exchange: nasdaq)
Assets::Ticker.find_or_create_by!(ticker: 'BRK/B', asset: berkshire_hathaway, exchange: nasdaq)
Assets::CUSIP.find_or_create_by!(cusip: '084670702', asset: berkshire_hathaway, exchange: nasdaq)
Assets::SEDOL.find_or_create_by!(sedol: '2073390', asset: berkshire_hathaway, exchange: nasdaq)
