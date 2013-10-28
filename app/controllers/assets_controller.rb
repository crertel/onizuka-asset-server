class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy]


  def index
    @assets = Asset.all
    respond_to do |format|
      format.html
      format.json { render json: @assets }
    end
  end


  def show
    respond_to do |format|
      format.html
      format.json { render json: @asset }
    end
  end


  def new
    @asset = Asset.new
  end


  def edit
  end


  def create
    @asset = Asset.new(asset_params)

    if @asset.save
      redirect_to @asset, notice: 'Asset was successfully created.'
    else
      render action: 'new'
    end
  end


  def update
    if @asset.update(asset_params)
      redirect_to @asset, notice: 'Asset was successfully updated.'
    else
      render action: 'edit'
    end
  end


  def destroy
    @asset.destroy
    redirect_to assets_url, notice: 'Asset was successfully destroyed.'
  end


  private


    def set_asset
      @asset = Asset.find(params[:id])
    end


    def asset_params
      params[:asset]
    end
end
