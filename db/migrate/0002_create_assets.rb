class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.string :name
      t.string :type
      t.string :ticker
      t.string :sector

      t.timestamps
    end
  end
end
