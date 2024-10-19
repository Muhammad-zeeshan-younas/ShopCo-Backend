module ApiException
  class MerchantError < ApiException::BaseException
    class NotFound < ApiException::MerchantError
      def initialize
        super("Merchant not found", 404)
      end
    end
  end
end