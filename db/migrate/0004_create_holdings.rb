# frozen_string_literal: true

class CreateHoldings < ActiveRecord::Migration[7.1]
  def change
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
