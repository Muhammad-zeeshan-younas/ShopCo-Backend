class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_user_from_token!
    token = request.headers['Authorization']&.split(' ')&.last
    byebug
    if token
      begin
        # Decode the JWT token (ensure to use your app's secret key)
        decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
        user_id = decoded_token[0]["sub"] # Assuming the user ID is stored in the 'sub' field
        @current_user = User.find(user_id)
      rescue JWT::DecodeError => e
        render json: { error: "Invalid token", message: e.message }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :unauthorized
      end
    else
      render json: { error: "Missing token" }, status: :unauthorized
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :avatar])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
