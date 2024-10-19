module ApiException
  class ContainerError < ApiException::BaseException
    class InvalidBarcode < ApiException::ContainerError
      def initialize
        super("Invalid barcode", 404)
      end
    end
  end
end
