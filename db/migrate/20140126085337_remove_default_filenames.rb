class RemoveDefaultFilenames < ActiveRecord::Migration
  def up
    change_column :assets, :file_name, :string, null: false
    change_column :assets, :slug_name, :string, null: false
  end

  def down
    add_column :assets, :file_name, :string, null: false, default: ''
    add_column :assets, :slug_name, :string, null: false, default: ''
  end
end
