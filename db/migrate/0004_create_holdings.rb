class CreateHoldings < ActiveRecord::Migration[7.1]
  def change
    create_table :holdings do |t|
      t.references :fund, null: false, foreign_key: true
      t.references :asset, null: false, foreign_key: true
      t.date :date, null: false
      t.decimal :quantity, default: 0, null: false
      t.monetize :price
      t.monetize :market_price

      t.timestamps
    end
  end
end
