class CreateAssetsManagers < ActiveRecord::Migration[7.1]
  def change
    create_table :assets_managers do |t|
      t.string :name

      t.timestamps
    end
  end
end
