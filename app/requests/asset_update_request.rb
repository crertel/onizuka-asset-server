class AssetUpdateRequest

  attr_reader :asset, :asset_attributes

  def initialize(params: )
    @asset            = determine_asset(params)
    @asset_attributes = determine_asset_attributes(params)
  end


  def determine_asset(params)
    Asset.find(params.fetch(:id))
  rescue # Whether an error via find or via fetch.
    :not_found
  end


  def determine_asset_attributes(params)
    split_tags(
      params.fetch(:asset, {})
            .permit(*allowed_param_keys))
  end


private #######################################################################


  def split_tags(params)
    return params unless params.key?(:tags)
    params[:tags] = (params[:tags] || "").split(/[\s,\n]+/).uniq
    params
  end


  def allowed_param_keys
    [ :display_name,
      :description,
      :tags,
      :content_type,
      :slug_name,
      :asset
    ]
  end

end