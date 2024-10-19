module ApiException
  class PaymentError < ApiException::BaseException
    class PaymentNotFound < ApiException::PaymentError
      def initialize
        super("Payment not found", 400)
      end
    end
  end
end
