module ApiException
  class PosError < ApiException::BaseException
    class InvalidBarcode < ApiException::PosError
      def initialize
        super("Invalid barcode", 404)
      end
    end
  end
end
