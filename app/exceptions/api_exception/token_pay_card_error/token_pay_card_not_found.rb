module ApiException
  class TokenPayCardError < ApiException::BaseException
    class TokenPayCardNotFound < ApiException::TokenPayCardError
      def initialize
        super("Token pay card not found", 404)
      end
    end
  end
end
