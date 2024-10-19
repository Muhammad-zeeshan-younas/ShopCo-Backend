module ApiException
  class GenericError < ApiException::BaseException
    class InvalidRequest < ApiException::GenericError
      def initialize
        super("Invalid request", 400)
      end
    end
  end
end
