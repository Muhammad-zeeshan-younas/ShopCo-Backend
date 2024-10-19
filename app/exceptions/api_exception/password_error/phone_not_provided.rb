module ApiException
  class PasswordError < ApiException::BaseException
    class PhoneNotProvided < ApiException::PasswordError
      def initialize
        super("Phone not provided", 400)
      end
    end
  end
end
