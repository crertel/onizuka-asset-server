class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # All controllers, when delivering json via an ActiveModel::Serializer,
  # not include the { "model_name" : {...} } root node by default.
  def default_serializer_options
    { root: false }
  end

end
