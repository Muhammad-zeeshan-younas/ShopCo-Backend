class Users::SessionsController < DeviseTokenAuth::SessionsController
    def create
        params[:phone] = Phonelib.parse(params[:phone]).full_e164
        super
      end
  
      protected
  
      def render_create_error_bad_credentials
        raise ApiException::UserError::UserNotAuthenticated
      end
  
      def render_create_error_not_confirmed
        raise ApiException::UserError::UserNotVerified
      end
  
      def render_create_success
        render json: { user: UserBlueprint.render_as_json(@resource) }, status: :ok
      end
  
      def provider
        "email"
      end
  end
  