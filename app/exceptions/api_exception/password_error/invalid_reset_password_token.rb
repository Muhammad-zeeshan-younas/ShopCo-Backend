module ApiException
  class PasswordError < ApiException::BaseException
    class InvalidResetPasswordToken < ApiException::PasswordError
      def initialize
        super("Invalid password reset token", 400)
      end
    end
  end
end
