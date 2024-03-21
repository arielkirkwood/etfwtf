# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

ishares = Assets::Manager.find_or_create_by!(name: 'iShares')
crbn_asset = Asset.find_or_create_by!(name: 'iShares MSCI ACWI Low Carbon Target ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Global Large-Stock Blend')
Assets::Ticker.find_or_create_by!(asset: crbn_asset, ticker: 'CRBN')
crbn_fund = Fund.find_or_initialize_by(underlying_asset: crbn_asset)
crbn_fund.update(public_url: 'https://www.ishares.com/us/products/271054/',
                 holdings_url: 'https://www.ishares.com/us/products/271054/fund/1467271812596.ajax?fileType=csv&fileName=CRBN_holdings&dataType=fund',
                 manager: ishares)
bgrn_asset = Asset.find_or_create_by!(name: 'iShares USD Green Bond ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Global Bond-USD Hedged')
Assets::Ticker.find_or_create_by!(asset: bgrn_asset, ticker: 'BGRN')
bgrn_fund = Fund.find_or_initialize_by(underlying_asset: bgrn_asset)
bgrn_fund.update(public_url: 'https://www.ishares.com/us/products/305296/',
                 holdings_url: 'https://www.ishares.com/us/products/305296/fund/1467271812596.ajax?fileType=csv&fileName=BGRN_holdings&dataType=fund',
                 manager: ishares)
ivv_asset = Asset.find_or_create_by!(name: 'iShares Core S&P 500 ETF',
                                     type: 'ExchangeTradedFund',
                                     sector: 'Large Blend')
Assets::Ticker.find_or_create_by!(asset: ivv_asset, ticker: 'IVV')
ivv_fund = Fund.find_or_initialize_by(underlying_asset: ivv_asset)
ivv_fund.update(public_url: 'https://www.ishares.com/us/products/239726/',
                holdings_url: 'https://www.ishares.com/us/products/239726/fund/1467271812596.ajax?fileType=csv&fileName=IVV_holdings&dataType=fund',
                manager: ishares)
stip_asset = Asset.find_or_create_by!(name: 'iShares 0-5 Year TIPS Bond ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Inflation-Protected Bond')
Assets::Ticker.find_or_create_by!(asset: stip_asset, ticker: 'STIP')
stip_fund = Fund.find_or_initialize_by(underlying_asset: stip_asset)
stip_fund.update(public_url: 'https://www.ishares.com/us/products/239450/',
                 holdings_url: 'https://www.ishares.com/us/products/239450/fund/1467271812596.ajax?fileType=csv&fileName=STIP_holdings&dataType=fund',
                 manager: ishares)
emb_asset = Asset.find_or_create_by!(name: 'iShares J.P. Morgan USD Emerging Markets Bond ETF',
                                     type: 'ExchangeTradedFund',
                                     sector: 'Emerging Markets Bond')
Assets::Ticker.find_or_create_by!(asset: emb_asset, ticker: 'EMB')
emb_fund = Fund.find_or_initialize_by(underlying_asset: emb_asset)
emb_fund.update(public_url: 'https://www.ishares.com/us/products/239572/',
                holdings_url: 'https://www.ishares.com/us/products/239572/fund/1467271812596.ajax?fileType=csv&fileName=EMB_holdings&dataType=fund',
                manager: ishares)

tcw = Assets::Manager.find_or_create_by!(name: 'TCW')
vote_asset = Asset.find_or_create_by!(name: 'TCW Transform 500 ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Large Blend')
vote_fund = Fund.find_or_initialize_by(underlying_asset: vote_asset)
vote_fund.update(public_url: 'https://etf.tcw.com/vote/',
                 holdings_url: 'https://etf.tcw.com/VOTE_holdings_20240320_080001.xlsx',
                 manager: tcw)

state_street = Assets::Manager.find_or_create_by!(name: 'State Street')
spyx_asset = Asset.find_or_create_by!(name: 'SPDR® S&P® 500 Fossil Fuel Reserves Free ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Large Blend')
Assets::Ticker.find_or_create_by!(asset: spyx_asset, ticker: 'SPYX')
spyx_fund = Fund.find_or_initialize_by(underlying_asset: spyx_asset)
spyx_fund.update(public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-sp-500-fossil-fuel-reserves-free-etf-spyx',
                 holdings_url: 'https://www.ssga.com/us/en/individual/etfs/library-content/products/fund-data/etfs/us/holdings-daily-us-en-spyx.xlsx',
                 manager: state_street)
efax_asset = Asset.find_or_create_by!(name: 'SPDR® MSCI EAFE Fossil Fuel Reserves Free ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Foreign Large Blend')
Assets::Ticker.find_or_create_by!(asset: efax_asset, ticker: 'EFAX')
efax_fund = Fund.find_or_initialize_by(underlying_asset: efax_asset)
efax_fund.update(public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-msci-eafe-fossil-fuel-reserves-free-etf-efax',
                 holdings_url: 'https://www.ssga.com/us/en/individual/etfs/library-content/products/fund-data/etfs/us/holdings-daily-us-en-efax.xlsx',
                 manager: state_street)
eemx_asset = Asset.find_or_create_by!(name: 'SPDR® MSCI Emerging Markets Fossil Fuel Reserves Free ETF',
                                      type: 'ExchangeTradedFund',
                                      sector: 'Diversified Emerging Markets')
Assets::Ticker.find_or_create_by!(asset: eemx_asset, ticker: 'EEMX')
eemx_fund = Fund.find_or_initialize_by(underlying_asset: eemx_asset)
eemx_fund.update(public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-msci-emerging-markets-fossil-fuel-reserves-free-etf-eemx',
                 holdings_url: 'https://www.ssga.com/us/en/individual/etfs/library-content/products/fund-data/etfs/us/holdings-daily-us-en-eemx.xlsx',
                 manager: state_street)

crbn_fund.extract_holdings
bgrn_fund.extract_holdings
ivv_fund.extract_holdings
stip_fund.extract_holdings
emb_fund.extract_holdings
vote_fund.save
spyx_fund.save
efax_fund.save
eemx_fund.save
