class AssetSerializer < ActiveModel::Serializer
  attributes  :id, :display_name, :description, :tags, :content_type,
              :file_size, :updated_at, :created_at, :file_path, :asset_type,
              :file_name


  def file_path
    Rails.application.routes.url_helpers.file_path(object.id)
  end


  def asset_type
    object.type and object.type.underscore
  end


  def file_name
    object.asset.file and object.asset.file.filename
  end

end
