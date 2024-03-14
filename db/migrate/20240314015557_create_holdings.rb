class CreateHoldings < ActiveRecord::Migration[7.1]
  def change
    create_table :holdings do |t|
      t.references :fund, null: false, foreign_key: true
      t.references :asset, null: false, foreign_key: true

      t.timestamps
    end
  end
end
