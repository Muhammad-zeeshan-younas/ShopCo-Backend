module ApiException
  class UserError < ApiException::BaseException
    class UserNotVerified < ApiException::UserError
      def initialize
        super("User not verified", 400)
      end
    end
  end
end
