# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 4) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'assets', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'type', null: false
    t.string 'ticker', null: false
    t.string 'sector'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'assets_managers', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'fund_holdings_file_format', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'funds', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'public_url', null: false
    t.string 'holdings_url', null: false
    t.bigint 'underlying_asset_id', null: false
    t.bigint 'manager_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['manager_id'], name: 'index_funds_on_manager_id'
    t.index ['underlying_asset_id'], name: 'index_funds_on_underlying_asset_id'
  end

  create_table 'holdings', force: :cascade do |t|
    t.bigint 'fund_id', null: false
    t.bigint 'asset_id', null: false
    t.date 'date', null: false
    t.decimal 'quantity', default: '0.0', null: false
    t.integer 'price_cents', default: 0, null: false
    t.string 'price_currency', default: 'USD', null: false
    t.integer 'market_price_cents', default: 0, null: false
    t.string 'market_price_currency', default: 'USD', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['asset_id'], name: 'index_holdings_on_asset_id'
    t.index ['fund_id'], name: 'index_holdings_on_fund_id'
  end

  add_foreign_key 'funds', 'assets', column: 'underlying_asset_id'
  add_foreign_key 'funds', 'assets_managers', column: 'manager_id'
  add_foreign_key 'holdings', 'assets'
  add_foreign_key 'holdings', 'funds'
end
