module ApiException
  class PaymentError < ApiException::BaseException
    class CreditLessThenZero < ApiException::PaymentError
      def initialize
        super("Credit amount should be greater then 0", 400)
      end
    end
  end
end
