# frozen_string_literal: true

class CreateAssetsExchanges < ActiveRecord::Migration[7.1]
  def change
    create_table :assets_exchanges do |t|
      t.timestamps

      t.string :name

      t.index :name, unique: true
    end

    change_table :assets_identities do |t|
      t.belongs_to :exchange, foreign_key: { to_table: :assets_exchanges }

      t.index [:identifier, :exchange_id], unique: true
    end
  end
end
