class MigrateFilenamesForAssets < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do
      Asset.all.each do |asset|
        asset.capture_file_name
        asset.generate_slug_name
        asset.save
      end
    end
  end

  def down
    raise NotImplementedError.new
  end
end
