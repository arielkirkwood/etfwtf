class CreateHoldingsPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :holdings_prices do |t|
      t.belongs_to :asset, null: false, foreign_key: true
      t.date :date, null: false
      t.monetize :notional_value, null: false
      t.monetize :unit_price, null: false
      t.monetize :market_price, null: false

      t.timestamps
    end

    change_table :holdings do |t|
      t.belongs_to :price, foreign_key: { to_table: :holdings_prices }

      t.index [:fund_id, :date, :quantity, :price_id], unique: true
    end
  end
end
