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

ActiveRecord::Schema[7.1].define(version: 2024_03_24_175339) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "type", null: false
    t.string "sector"
  end

  create_table "assets_exchanges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["name"], name: "index_assets_exchanges_on_name", unique: true
  end

  create_table "assets_identities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "asset_id", null: false
    t.string "type", null: false
    t.string "identifier", null: false
    t.bigint "exchange_id"
    t.index ["asset_id"], name: "index_assets_identities_on_asset_id"
    t.index ["exchange_id"], name: "index_assets_identities_on_exchange_id"
    t.index ["identifier", "exchange_id"], name: "index_assets_identities_on_identifier_and_exchange_id", unique: true
  end

  create_table "assets_managers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "holdings_link_text", null: false
  end

  create_table "funds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "manager_id", null: false
    t.bigint "underlying_asset_id", null: false
    t.string "public_url", null: false
    t.index ["manager_id"], name: "index_funds_on_manager_id"
    t.index ["underlying_asset_id"], name: "index_funds_on_underlying_asset_id"
  end

  create_table "holdings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "fund_id", null: false
    t.date "date", null: false
    t.decimal "quantity", null: false
    t.date "accrual_date"
    t.bigint "price_id"
    t.index ["fund_id"], name: "index_holdings_on_fund_id"
    t.index ["price_id", "fund_id", "date"], name: "index_holdings_on_price_id_and_fund_id_and_date", unique: true
    t.index ["price_id"], name: "index_holdings_on_price_id"
  end

  create_table "holdings_prices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "asset_id", null: false
    t.date "date", null: false
    t.integer "notional_value_cents", default: 0, null: false
    t.string "notional_value_currency", default: "USD", null: false
    t.integer "unit_price_cents", default: 0, null: false
    t.string "unit_price_currency", default: "USD", null: false
    t.integer "market_price_cents", default: 0, null: false
    t.string "market_price_currency", default: "USD", null: false
    t.index ["asset_id"], name: "index_holdings_prices_on_asset_id"
  end

  add_foreign_key "assets_identities", "assets"
  add_foreign_key "assets_identities", "assets_exchanges", column: "exchange_id"
  add_foreign_key "funds", "assets", column: "underlying_asset_id"
  add_foreign_key "funds", "assets_managers", column: "manager_id"
  add_foreign_key "holdings", "funds"
  add_foreign_key "holdings", "holdings_prices", column: "price_id"
  add_foreign_key "holdings_prices", "assets"
end
