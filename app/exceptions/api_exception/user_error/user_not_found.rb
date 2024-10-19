module ApiException
  class UserError < ApiException::BaseException
    class UserNotFound < ApiException::UserError
      def initialize
        super("User not found", 404)
      end
    end
  end
end
