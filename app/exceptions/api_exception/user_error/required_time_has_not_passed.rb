module ApiException
  class UserError < ApiException::BaseException
    class RequiredTimeHasNotPassed < ApiException::UserError
      def initialize
        super("Wait 2 minute before requesting a message resend", 400)
      end
    end
  end
end
