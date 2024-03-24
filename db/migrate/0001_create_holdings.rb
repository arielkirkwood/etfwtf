# frozen_string_literal: true

class CreateHoldings < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    create_table :assets_managers do |t|
      t.string :name, null: false
      t.string :holdings_link_text, null: false

      t.timestamps
    end

    create_table :assets do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.string :sector

      t.timestamps
    end

    create_table :assets_identities do |t|
      t.references :asset, null: false, foreign_key: true
      t.string :type, null: false
      t.string :identifier, null: false

      t.index [:asset_id, :identifier], unique: true
      t.timestamps
    end

    create_table :funds do |t|
      t.belongs_to :manager, null: false, foreign_key: { to_table: :assets_managers }
      t.belongs_to :underlying_asset, null: false, foreign_key: { to_table: :assets }
      t.string :public_url, null: false

      t.timestamps
    end

    create_table :holdings do |t|
      t.belongs_to :fund, null: false, foreign_key: true
      t.date :date, null: false
      t.decimal :quantity, null: false
      t.date :accrual_date

      t.timestamps
    end
  end
end
