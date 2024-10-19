module ApiException
  class OrderError < ApiException::BaseException
    class Canceled < ApiException::OrderError
      def initialize
        super("Order is canceled", 400)
      end
    end
  end
end
