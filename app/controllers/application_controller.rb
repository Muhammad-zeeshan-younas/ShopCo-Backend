class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :avatar])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
