module ApiException
  class PosError < ApiException::BaseException
    class MerchantNotAuthenticated < ApiException::PosError
      def initialize
        super("Invalid credentials", 401)
      end
    end
  end
end
