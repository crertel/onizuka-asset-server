class Asset < ActiveRecord::Base
  # Because ActiveRecord is magic and doesn't require we list our attributes,
  # we'll have to do it here in a comment:
  # file, display_name, description, tags, content_type, file_size

  mount_uploader :asset, AssetUploader

  validates :asset,         presence: true
  validates :display_name,  presence: true
  validates :content_type,  presence: true
  validates :file_size,     presence: true

  before_validation :update_asset_metadata

  # Convenience methods for ActiveRecord attributes must be aliased
  # using alias_attribute, rather than alias_method.
  alias_attribute :mime_type, :content_type

  # Provide a shortcut into the CarrierWave::SanitizedFile for convenience.
  def file
    asset.present? ? asset.file : nil
  end


  def file_name
    asset.present? ? asset.filename : ""
  end


private #######################################################################

  # Set the content_type and file_size from our asset if necessary.
  def update_asset_metadata
    if self.asset.present? and self.asset_changed?
      self.content_type = self.file.content_type
      self.content_type = "application/text" if self.content_type.blank?
      self.file_size    = self.file.size
    end
  end

end
