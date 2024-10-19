module ApiException
  class ProductException < ApiException::BaseException
    class ProductNotFound < ApiException::ProductException
      def initialize
        super("Product not found", 404)
      end
    end
  end
end
