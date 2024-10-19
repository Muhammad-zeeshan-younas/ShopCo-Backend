module ApiException
  class OrderError < ApiException::BaseException
    class TooMuchItems < ApiException::OrderError
      def initialize
        super("The maximum number of items for an order was reached. Please decrease it to contunue with your order.", 400)
      end
    end
  end
end
