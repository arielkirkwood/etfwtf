# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

  ishares = Assets::Manager.find_or_create_by!(name: 'iShares')
  crbn_asset = Asset.find_or_create_by!(name: 'iShares MSCI ACWI Low Carbon Target ETF',
                                        type: 'ExchangeTradedFund',
                                        ticker: 'CRBN',
                                        sector: 'Global Large-Stock Blend')
  crbn_fund = Fund.find_or_initialize_by(name: 'iShares MSCI ACWI Low Carbon Target ETF')
  crbn_fund.update(public_url: 'https://www.ishares.com/us/products/271054/',
                   holdings_url: 'https://www.ishares.com/us/products/271054/fund/1467271812596.ajax?fileType=csv&fileName=CRBN_holdings&dataType=fund',
                   underlying_asset: crbn_asset,
                   manager: ishares)
  bgrn_asset = Asset.find_or_create_by!(name: 'iShares USD Green Bond ETF',
                                        type: 'ExchangeTradedFund',
                                        ticker: 'BGRN',
                                        sector: 'Global Bond-USD Hedged')
  bgrn_fund = Fund.find_or_initialize_by(name: 'iShares USD Green Bond ETF')
  bgrn_fund.update(public_url: 'https://www.ishares.com/us/products/305296/',
                   holdings_url: 'https://www.ishares.com/us/products/305296/fund/1467271812596.ajax?fileType=csv&fileName=BGRN_holdings&dataType=fund',
                   underlying_asset: bgrn_asset,
                   manager: ishares)

  state_street = Assets::Manager.find_or_create_by!(name: 'State Street')
  spyx_asset = Asset.find_or_create_by!(name: 'SPDR® S&P® 500 Fossil Fuel Reserves Free ETF',
                                        type: 'ExchangeTradedFund',
                                        ticker: 'SPYX',
                                        sector: 'Large Blend')
  spyx_fund = Fund.find_or_initialize_by(name: 'SPDR® S&P® 500 Fossil Fuel Reserves Free ETF')
  spyx_fund.update(public_url: 'https://www.ssga.com/us/en/individual/etfs/funds/spdr-sp-500-fossil-fuel-reserves-free-etf-spyx',
                   holdings_url: 'https://www.ssga.com/us/en/individual/etfs/library-content/products/fund-data/etfs/us/holdings-daily-us-en-spyx.xlsx',
                   underlying_asset: spyx_asset,
                   manager: state_street)

  crbn_fund.save
  bgrn_fund.save
  spyx_fund.save
