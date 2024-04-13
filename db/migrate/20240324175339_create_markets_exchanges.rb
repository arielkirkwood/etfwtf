# frozen_string_literal: true

class CreateMarketsExchanges < ActiveRecord::Migration[7.1]
  def change
    create_table :markets_exchanges do |t|
      t.timestamps

      t.string :name
    end

    change_table :assets_identities do |t|
      t.belongs_to :exchange, foreign_key: { to_table: :markets_exchanges }

      t.index [:identifier, :exchange_id], unique: true
    end
  end
end
