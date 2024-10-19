module ApiException
  class PasswordError < ApiException::BaseException
    class EmailNotProvided < ApiException::PasswordError
      def initialize
        super("Email not provided", 400)
      end
    end
  end
end
