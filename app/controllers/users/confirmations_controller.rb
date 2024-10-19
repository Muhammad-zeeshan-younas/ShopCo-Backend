class Users::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
    before_action :find_resource_for_create, only: [:create]
    before_action :required_time_has_passed_for_resend, only: [:create]

    def create
      return render_create_success if @resource.nil?

      yield @resource if block_given?

      @resource.send_confirmation_instructions
      @resource.update!(confirmation_sent_at: Time.now)

      return render_create_success if @resource.errors.empty?

      render_create_error @resource.errors
    end

    def show
      @resource = resource_class.confirm_by_token(resource_params[:confirmation_token])
      if @resource.errors.empty?
        yield @resource if block_given?
        user = signed_in?(resource_name) ? signed_in_resource : @resource
        redirect_to_link = user.build_auth_url(redirect_url, generate_success_redirect_headers(user))
        redirect_to(redirect_to_link)
      else
        redirect_to_login_page_on_frontend
      end
    end

    protected

    def provider
      'email'
    end

    def render_create_success
      render json: { message: "Account confirmation instructions were sent to #{resource_params[:email]}" }, status: :ok
    end

    def render_create_error_missing_email
      raise ApiException::PasswordError::EmailNotProvided
    end

    def render_error_required_time_has_not_passed
      raise ApiException::UserError::RequiredTimeHasNotPassed
    end

    private

    def resource_params
      params.permit(:email, :confirmation_token)
    end

    def find_resource_for_create
      return render_create_error_missing_email unless resource_params[:email]

      @resource = User.find_by(email: resource_params[:email])
    end

    def required_time_has_passed_for_resend
      return unless @resource&.confirmation_sent_at

      render_error_required_time_has_not_passed if @resource.confirmation_sent_at > 2.minute.ago
    end

    def generate_success_redirect_headers(user)
      redirect_header_options = { account_confirmation_success: true }

      token = user.create_token
      user.save!

      build_redirect_headers(token.token, token.client, redirect_header_options)
    end

    def redirect_to_login_page_on_frontend
      redirect_to "#{ENV['FRONTEND_URL']}?confirmation_token_error=#{@resource.errors.full_messages.first}"
    end
  end