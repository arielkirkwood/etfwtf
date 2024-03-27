# frozen_string_literal: true

class CreateHoldingsPriceTypes < ActiveRecord::Migration[7.1]
  def change # rubocop:disable Metrics/MethodLength
    change_table :holdings_prices, bulk: true do |t|
      t.references :priceable, polymorphic: true
    end

    create_table :holdings_bond_prices do |t|
      t.timestamps

      t.monetize :par_value, null: false
      t.decimal :coupon_rate, null: false
      t.date :maturity_date, null: false
    end

    create_table :holdings_equity_prices do |t|
      t.timestamps

      t.monetize :notional_value, null: false
      t.monetize :unit_price, null: false
      t.monetize :market_price, null: false
    end
  end
end
