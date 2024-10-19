class Users::PasswordsController < DeviseTokenAuth::PasswordsController
    before_action :find_resource_for_create, only: [:create]
    before_action :required_time_has_passed_for_resend, only: [:create]
    before_action :find_resource_for_update, only: [:update]

    # rubocop:disable Metrics/AbcSize
    def create
      return render_create_success if @resource.nil?

      required_time_has_passed_for_resend

      yield @resource if block_given?

      @resource.send_reset_password_instructions

      return render_create_success if @resource.errors.empty?

      render_create_error @resource.errors
    end

    def update
      return render_update_error_unauthorized unless @resource
      return render_update_error_password_not_required unless @resource.provider == 'email'
      return render_update_error_missing_password unless password_resource_params[:password]

      if @resource.send(resource_update_method, password_resource_params)
        @resource.allow_password_change = false if recoverable_enabled?
        @resource.save!

        yield @resource if block_given?

      else
        render_update_error
      end
    end
    # rubocop:enable Metrics/AbcSize

    protected

    def render_create_success
      render json: { message: "Password reset instructions were sent to #{resource_params[:email]}" }, status: :ok
    end

    def render_create_error_missing_email
      raise ApiException::PasswordError::EmailNotProvided
    end

    def render_error_required_time_has_not_passed
      raise ApiException::UserError::RequiredTimeHasNotPassed
    end

    def render_update_error
      raise ApiException::PasswordError::InvalidResetPasswordToken
    end

    def render_update_error_unauthorized
      raise ApiException::PasswordError::InvalidResetPasswordToken
    end

    private

    def provider
      "email"
    end

    def find_resource_for_create
      return render_create_error_missing_email unless resource_params[:email]

      @resource = User.find_by(email: resource_params[:email])
    end

    def required_time_has_passed_for_resend
      return unless @resource&.reset_password_sent_at

      render_error_required_time_has_not_passed if @resource.reset_password_sent_at > 2.minute.ago
    end

    def find_resource_for_update
      if require_client_password_reset_token? && resource_params[:reset_password_token]

        @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])

        return render_update_error_unauthorized unless @resource

        @token = @resource.create_token
      else
        @resource = set_user_by_token
      end
    end

    def resource_params
      params.permit(:email, :password, :reset_password_token)
    end

    def password_resource_params
      params.permit(:email, :password, :reset_password_token)
    end
  end