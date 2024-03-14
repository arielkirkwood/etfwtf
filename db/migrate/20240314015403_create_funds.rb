class CreateFunds < ActiveRecord::Migration[7.1]
  def change
    create_table :funds do |t|
      t.string :name
      t.string :public_url
      t.string :holdings_url
      t.references :asset, null: false, foreign_key: true

      t.timestamps
    end
  end
end
