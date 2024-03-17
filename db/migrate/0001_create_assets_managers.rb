class CreateAssetsManagers < ActiveRecord::Migration[7.1]
  def change
    create_table :assets_managers do |t|
      t.string :name, null: false
      t.string :fund_holdings_file_format, null: false

      t.timestamps
    end
  end
end
