# frozen_string_literal: true

class CreateMarketsExchanges < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/MethodLength
    create_table :markets_exchanges, id: :string, primary_key: 'market_identification_code' do |t|
      t.timestamps

      t.string :name
      t.string :operating_market_identification_code, null: false, index: true
      t.string :legal_entity_name
      t.string :country
      t.string :status
    end

    change_table :assets do |t|
      t.string :market_identification_code

      t.index [:id, :market_identification_code], unique: true
    end

    add_foreign_key :assets, :markets_exchanges, column: :market_identification_code, primary_key: :market_identification_code
  end
end
