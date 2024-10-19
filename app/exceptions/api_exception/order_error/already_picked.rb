module ApiException
  class OrderError < ApiException::BaseException
    class AlreadyPicked < ApiException::OrderError
      def initialize
        super("Order already picked", 400)
      end
    end
  end
end
