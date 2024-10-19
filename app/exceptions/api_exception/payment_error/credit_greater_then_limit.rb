module ApiException
  class PaymentError < ApiException::BaseException
    class CreditGreaterThenLimit < ApiException::PaymentError
      def initialize
        super("You cannot add more than 999 credits", 400)
      end
    end
  end
end
