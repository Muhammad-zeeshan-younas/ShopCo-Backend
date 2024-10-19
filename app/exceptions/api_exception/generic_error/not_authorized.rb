module ApiException
  class GenericError < ApiException::BaseException
    class NotAuthorized < ApiException::GenericError
      def initialize
        super("You are not authorized", 403)
      end
    end
  end
end

