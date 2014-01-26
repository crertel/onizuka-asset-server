class AssetUpdate

  attr_reader :request, :listener

  delegate :asset, :asset_attributes,
            to: :request

  def initialize(listener: , request: )
    @listener = listener
    @request  = request
  end


  def apply
    reject and return if asset == :not_found
    update_asset_attributes ? accept : reject
  end



private #######################################################################


  def update_asset_attributes
    asset.update_attributes(asset_attributes)
  end


  def accept
    listener.update_succeeded(asset: asset, message: 'Asset was successfully updated.')
  end


  def reject
    listener.update_failed(asset: asset, message: '')
  end

end