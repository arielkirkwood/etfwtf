# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

  crbn_asset = Asset.find_or_create_by!(name: 'iShares MSCI ACWI Low Carbon Target ETF',
                                        type: 'Equity',
                                        ticker: 'CRBN',
                                        sector: 'Global Large-Stock Blend')
  crbn_fund = Fund.find_or_initialize_by(name: 'iShares MSCI ACWI Low Carbon Target ETF')
  crbn_fund.update(public_url: 'https://www.ishares.com/us/products/271054/ishares-msci-acwi-low-carbon-target-etf',
                   holdings_url: 'https://www.ishares.com/us/products/271054/ishares-msci-acwi-low-carbon-target-etf/1467271812596.ajax?fileType=csv&fileName=CRBN_holdings&dataType=fund',
                   asset_id: crbn_asset.id)
  crbn_fund.save
