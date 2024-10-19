module ApiException
  class OrderError < ApiException::BaseException
    class OrderNotFound < ApiException::OrderError
      def initialize
        super("Order not found", 404)
      end
    end
  end
end
