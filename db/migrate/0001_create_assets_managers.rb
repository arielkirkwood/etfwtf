# frozen_string_literal: true

class CreateAssetsManagers < ActiveRecord::Migration[7.1]
  def change
    create_table :assets_managers do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
