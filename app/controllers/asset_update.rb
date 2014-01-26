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


  def accept

  end


  def reject

  end

end