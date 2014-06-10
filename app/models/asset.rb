class Asset < ActiveRecord::Base
  # Because ActiveRecord is magic and doesn't require we list our attributes,
  # we'll have to do it here in a comment:
  # file, display_name, description, tags, content_type, file_size

  mount_uploader :asset, AssetUploader

  validates :asset,         presence: true
  validates :display_name,  presence: true
  validates :content_type,  presence: true
  validates :file_size,     presence: true
  validates :slug_name,     presence: true
  validates :file_name,     presence: true

  before_validation :update_asset_metadata
  before_validation :generate_slug_name, :if => :new_record?

  # Convenience methods for ActiveRecord attributes must be aliased
  # using alias_attribute, rather than alias_method.
  alias_attribute :mime_type, :content_type

  def self.valid_types
    [ImageAsset, MeshAsset, SoundAsset, MarkupAsset, ScriptAsset].map do |subclass|
      [subclass.name.chomp('Asset'), subclass.name]
    end
  end

  # Provide a shortcut into the CarrierWave::SanitizedFile for convenience.
  def file
    asset.present? ? asset.file : nil
  end


  def open_file(opts: {})
    File.open(asset.file.file, opts)
  end


  def relative_path
    "/#{Pathname.new(asset.file.path).relative_path_from(Rails.public_path)}"
  end


  def full_path
    self.asset.file.path
  end


  def checksum
    Digest::MD5.file(self.full_path).to_s
  end


  def capture_file_name
    self.file_name = self.file.filename if self.file.present?
  end


  def capture_file_size
    self.file_size = self.file.size
  end


  def capture_content_type
    self.content_type = self.file.content_type
    self.content_type = "application/text" if self.content_type.blank?
  end


  def generate_slug_name
    if self.slug_name.blank?
      # Get the filename, then remove its extension before snake_casing.
      fname = self.file.filename
      self.slug_name = fname.chomp(File.extname(fname)).parameterize.underscore
    end
  end

private #######################################################################

  # Set the content_type and file_size from our asset if necessary.
  def update_asset_metadata
    if self.asset.present? and self.asset_changed?
      capture_content_type
      capture_file_size
      capture_file_name
    end
  end

end
