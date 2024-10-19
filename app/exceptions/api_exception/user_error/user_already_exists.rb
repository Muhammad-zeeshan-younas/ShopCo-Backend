module ApiException
  class UserError < ApiException::BaseException
    class UserAlreadyExists < ApiException::UserError
      def initialize
        super("There exists already an account with this email", 400)
      end
    end
  end
end
