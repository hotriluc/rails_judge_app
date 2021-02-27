class ConfirmationsController  < Devise::ConfirmationsController


  private



  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    root_path
  end
end
