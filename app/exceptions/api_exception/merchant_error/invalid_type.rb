module ApiException
  class MerchantError < ApiException::BaseException
    class InvalidType < ApiException::MerchantError
      def initialize
        super("Merchant type is Invalid", 400)
      end
    end
  end
end
