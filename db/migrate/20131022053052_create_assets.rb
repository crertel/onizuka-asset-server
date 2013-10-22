class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      # Used by ActiveRecord for subclassing
      t.string  'type'

      t.string  'asset',        null: false
      t.string  'display_name', null: false
      t.text    'description'
      t.string  'tags',                       array: true, default: []
      t.string  'content_type', null: false
      t.integer 'file_size',    null: false

      t.timestamps
    end
  end
end
