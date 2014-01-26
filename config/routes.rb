OnizukaAssetServer::Application.routes.draw do

  resources :assets
  resources :image_assets,  controller: 'assets'
  resources :mesh_assets,   controller: 'assets'
  resources :sound_assets,  controller: 'assets'
  resources :script_assets, controller: 'assets'
  resources :markup_assets, controller: 'assets'

  # Embrace the ambiguity.
  get '/files/:id_or_name',
      to: 'files#get',
      as: 'file',
      constraints: { id_or_name: /.+/ }

end
