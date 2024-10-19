module ApiException
  class OrderError < ApiException::BaseException
    class AlreadyCompleted < ApiException::OrderError
      def initialize
        super("Order is already completed", 400)
      end
    end
  end
end