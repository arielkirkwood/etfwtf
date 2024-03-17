class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.string :ticker, null: false
      t.string :sector

      t.timestamps
    end
  end
end
