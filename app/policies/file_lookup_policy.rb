class FileLookupPolicy

  attr_reader :identifier, :asset_id

  def initialize(identifier: )
    @identifier = identifier
    @asset_id   = find_asset
  end


  def identified_by
    identification_method
  end


  def found?
    identification_method != :not_found
  end


  def filenamelike?(ident)
    ident =~ /.+\..+/
  end


  def slugnamelike?(ident)
    ident =~ /.*[[:alpha:]].*/
  end

private #######################################################################

  attr_accessor :identification_method


  def find_asset
    likely_method               = likely_lookup_method
    self.identification_method  = self.send("detect_as_#{likely_method}")
    found? ? fetch_id(identification_method) : :not_found
  end


  def likely_lookup_method
    detect_as_file_name and return :file_name if filenamelike?(identifier)
    detect_as_slug_name and return :slug_name if slugnamelike?(identifier)
    :integer_id
  end


  def detect_as_file_name
    return :file_name if Asset.where(file_name: identifier).exists?
    :not_found
  end


  def detect_as_slug_name
    return :slug_name if Asset.where(slug_name: identifier).exists?
    detect_as_file_name
  end


  def detect_as_integer_id
    return :id if Asset.where(id: identifier).exists?
    detect_as_slug_name
  end


  def fetch_id(attribute)
    Asset.where(attribute => identifier).pluck(:id)
  end

end
