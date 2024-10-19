module ApiException
  class OrderError < ApiException::BaseException
    class ActiveOrderAlreadyExists < ApiException::OrderError
      def initialize
        super("An active order for user already exists", 409)
      end
    end
  end
end