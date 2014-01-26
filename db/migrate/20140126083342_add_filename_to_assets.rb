class AddFilenameToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :file_name, :string, null: false, default: ''
    add_column :assets, :slug_name, :string, null: false, default: ''
  end
end
