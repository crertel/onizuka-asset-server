class AssetsController < ApplicationController
    require 'time'

  def index
    @assets = Asset.all
    respond_to do |format|
      format.html
      format.json { render json: @assets }
    end
  end


  def show
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @asset }
    end
  end


  def new
    # raise NotImplementedError.new
    @asset = Asset.new
  end


  def edit(asset: nil)
    @asset = asset || Asset.find(params[:id])
  end


  def create
    @asset = Asset.new(params[:asset])

    if @asset.save
        OnizukaAssetServer::Application.config.bunny.exchange.publish({:sid=>"", :time=>Time.now.utc.iso8601}.to_json,
                                                                    :routing_key => "assets.added.#{@asset.id}",
                                                                    :content_type=>"application/json")
       redirect_to @asset, notice: 'Asset was successfully created.'
    else
       render action: 'new'
    end
  end


  def update
    req = AssetUpdateRequest.new(params: params)
    AssetUpdate.new(listener: self, request: req).apply
  end


  def update_succeeded(asset: , message: )
    OnizukaAssetServer::Application.config.bunny.exchange.publish({:sid=>"", :time=>Time.now.utc.iso8601}.to_json,
                                                                    :routing_key => "asset.updated.#{params[:id]}",
                                                                    :content_type=>"application/json")
    redirect_to asset, notice: message
  end


  def update_failed(asset: , message: '')
    edit(asset: asset)
  end


  def destroy
    @asset = Asset.find(params[:id])    
    @asset.destroy
    
    
    OnizukaAssetServer::Application.config.bunny.exchange.publish({:sid=>"", :time=>Time.now.utc.iso8601}.to_json,
                                                                    :routing_key => "asset.removed.#{params[:id]}",
                                                                    :content_type=>"application/json")

    redirect_to assets_url, notice: 'Asset was successfully destroyed.'
  end

end
