# encoding: utf-8

class AssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick

  storage :file

  # Sets MIME Types as best it can.
  process :set_content_type

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  def extension_white_list
    script_extensions +
      image_extensions +
      model_extensions +
      material_extensions +
      manifest_extensions +
      sound_extensions
  end


  def script_extensions
    %w{lua js rb frag}
  end


  def image_extensions
    %w{jpg jpeg png bmp tga}
  end


  def model_extensions
    %w{obj}
  end


  def material_extensions
    %w{mtl}
  end


  def manifest_extensions
    %w{json}
  end


  def sound_extensions
    %w{wav ogg mp3}
  end

end
