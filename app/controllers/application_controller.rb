class ApplicationController < ActionController::Base
  before_action :configure_permitted_params, if: :devise_controller?





  def configure_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:teacher])
  end

  # Redirect after sign in
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end
end
