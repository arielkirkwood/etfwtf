# frozen_string_literal: true

class CreateFunds < ActiveRecord::Migration[7.1]
  def change
    create_table :funds do |t|
      t.string :name, null: false
      t.string :public_url, null: false
      t.string :holdings_url, null: false
      t.belongs_to :underlying_asset, null: false, foreign_key: { to_table: :assets }
      t.belongs_to :manager, null: false, foreign_key: { to_table: :assets_managers }

      t.timestamps
    end
  end
end
