module ApiException
  class OrderError < ApiException::BaseException
    class NotSelfService < ApiException::OrderError
      def initialize
        super("Order cannot be picked up from container. Please pick it up from a bar.", 400)
      end
    end
  end
end
