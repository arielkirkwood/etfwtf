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

ActiveRecord::Schema[7.1].define(version: 2024_03_27_214316) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "type", null: false
    t.string "sector"
    t.string "market_identification_code"
    t.index ["id", "market_identification_code"], name: "index_assets_on_id_and_market_identification_code", unique: true
  end

  create_table "assets_identities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "asset_id", null: false
    t.string "type", null: false
    t.string "identifier", null: false
    t.index ["asset_id", "identifier"], name: "index_assets_identities_on_asset_id_and_identifier", unique: true
    t.index ["asset_id"], name: "index_assets_identities_on_asset_id"
  end

  create_table "assets_managers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "holdings_link_text", null: false
    t.string "backup_holdings_link_text"
  end

  create_table "funds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "manager_id", null: false
    t.bigint "underlying_asset_id", null: false
    t.string "public_url", null: false
    t.index ["manager_id"], name: "index_funds_on_manager_id"
    t.index ["underlying_asset_id"], name: "index_funds_on_underlying_asset_id", unique: true
  end

  create_table "holdings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "asset_id", null: false
    t.bigint "portfolio_id", null: false
    t.decimal "quantity", null: false
    t.date "date"
    t.date "accrual_date"
    t.string "priceable_type"
    t.bigint "priceable_id"
    t.integer "notional_value_cents", default: 0, null: false
    t.string "notional_value_currency", default: "USD", null: false
    t.integer "market_value_cents", default: 0, null: false
    t.string "market_value_currency", default: "USD", null: false
    t.index ["asset_id"], name: "index_holdings_on_asset_id"
    t.index ["portfolio_id", "asset_id"], name: "index_holdings_on_portfolio_id_and_asset_id", unique: true
    t.index ["portfolio_id"], name: "index_holdings_on_portfolio_id"
    t.index ["priceable_type", "priceable_id"], name: "index_holdings_on_priceable"
  end

  create_table "holdings_bond_prices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "par_value_cents", default: 0, null: false
    t.string "par_value_currency", default: "USD", null: false
    t.decimal "coupon_rate", null: false
    t.date "maturity_date"
  end

  create_table "holdings_equity_prices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
  end

  create_table "markets_exchanges", primary_key: "market_identification_code", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "operating_market_identification_code", null: false
    t.string "legal_entity_name"
    t.string "country"
    t.string "status"
    t.index ["operating_market_identification_code"], name: "idx_on_operating_market_identification_code_a943b53c98"
  end

  create_table "portfolios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "fund_id", null: false
    t.date "date", null: false
    t.index ["fund_id"], name: "index_portfolios_on_fund_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assets", "markets_exchanges", column: "market_identification_code", primary_key: "market_identification_code"
  add_foreign_key "assets_identities", "assets"
  add_foreign_key "funds", "assets", column: "underlying_asset_id"
  add_foreign_key "funds", "assets_managers", column: "manager_id"
  add_foreign_key "holdings", "assets"
  add_foreign_key "holdings", "portfolios"
  add_foreign_key "portfolios", "funds"
end
