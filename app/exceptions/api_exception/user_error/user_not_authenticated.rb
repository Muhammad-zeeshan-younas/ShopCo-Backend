module ApiException
  class UserError < ApiException::BaseException
    class UserNotAuthenticated < ApiException::UserError
      def initialize
        super("Invalid email or password", 401)
      end
    end
  end
end
