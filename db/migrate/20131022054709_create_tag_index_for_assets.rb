class CreateTagIndexForAssets < ActiveRecord::Migration
  def change
    add_index 'assets', 'tags', using: 'gin'
  end
end
