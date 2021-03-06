class FileRetrieval

  attr_reader :listener, :asset_id, :asset, :file

  def initialize(listener, params)
    @listener = listener
    policy = FileLookupPolicy.new(identifier: params.fetch(:id_or_name))
    @asset_id = policy.asset_id
  end


  def apply
    find_asset &&
    find_file  &&
    success
  end


private #######################################################################


  def success
    listener.file_found(file)
    return true
  end


  def failure(message)
    listener.file_not_found(message)
    return false
  end


  def find_asset
    @asset    = :not_found if asset_id == :not_found
    @asset  ||= Asset.where(id: asset_id).first
    @asset  ||= :not_found
    return failure("Asset with ID '#{asset_id}' not found.") if asset == :not_found
    return true
  end


  def find_file
    # This looks and reads silly but is a combination of naming failure on our part
    # and on the part of carrierwave. A team effort.
    @file = asset.asset.file && asset.asset.file.file
    return failure("Asset with ID '#{asset_id}' found no file is present.") if file.nil?
    return true
  end

end
