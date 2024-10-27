class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
    def create
      
      super do |resource|
        if params[:avatar].present?
          resource.avatar.attach(params[:avatar]) # Attach the file to the user
        end
      end
    rescue ActiveRecord::RecordNotUnique
      # Custom exception handling for duplicate user (e.g., unique email constraint)
      raise ApiException::UserError::UserAlreadyExists, 'A user with this email already exists'
    end

    protected

    def provider
      'email'
    end

    def render_create_error
      raise ApiException::UserError::UserAlreadyExists
    end

    def render_update_success
      render json: { user: UserBlueprint.render_as_json(@resource) }, status: :ok
    end
    
    def render_create_success
      render json: { user: UserBlueprint.render_as_json(@resource) }, status: :ok
    end
  end