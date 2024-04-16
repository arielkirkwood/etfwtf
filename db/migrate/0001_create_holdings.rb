# frozen_string_literal: true

class CreateHoldings < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    create_table :assets_managers do |t|
      t.timestamps

      t.string :name, null: false
      t.string :holdings_link_text, null: false
      t.string :backup_holdings_link_text
    end

    create_table :assets do |t|
      t.timestamps

      t.string :name, null: false
      t.string :type, null: false
      t.string :sector
    end

    create_table :assets_identities do |t|
      t.timestamps

      t.references :asset, null: false, foreign_key: true

      t.string :type, null: false
      t.string :identifier, null: false

      t.index [:asset_id, :identifier], unique: true
    end

    create_table :funds do |t|
      t.timestamps

      t.belongs_to :manager, null: false, foreign_key: { to_table: :assets_managers }
      t.belongs_to :underlying_asset, null: false, foreign_key: { to_table: :assets }, index: { unique: true }

      t.string :public_url, null: false
    end

    create_table :portfolios do |t|
      t.timestamps

      t.belongs_to :fund, null: false, foreign_key: true

      t.date :date, null: false
    end

    create_table :holdings do |t|
      t.timestamps

      t.belongs_to :asset, null: false, foreign_key: true
      t.belongs_to :portfolio, null: false, foreign_key: true

      t.decimal :quantity, null: false
      t.date :date
      t.date :accrual_date
    end
  end
end
