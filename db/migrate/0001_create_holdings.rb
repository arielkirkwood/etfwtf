# frozen_string_literal: true

class CreateHoldings < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    create_table :assets_managers do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :assets do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.string :ticker, null: false
      t.string :sector

      t.index [:name, :ticker], unique: true
      t.timestamps
    end

    create_table :funds do |t|
      t.string :name, null: false
      t.string :public_url, null: false
      t.string :holdings_url, null: false
      t.belongs_to :underlying_asset, null: false, foreign_key: { to_table: :assets }
      t.belongs_to :manager, null: false, foreign_key: { to_table: :assets_managers }

      t.timestamps
    end

    create_table :holdings do |t|
      t.belongs_to :fund, null: false, foreign_key: true
      t.references :asset, null: false, foreign_key: true
      t.date :date, null: false
      t.decimal :quantity, default: 0, null: false
      t.monetize :price
      t.monetize :market_price
      t.date :accrual_date

      t.index [:fund_id, :asset_id, :date, :accrual_date], unique: true
      t.timestamps
    end
  end
end
