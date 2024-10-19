module ApiException
  class DispenserError < ApiException::BaseException
    class DispenserNotFound < ApiException::DispenserError
      def initialize
        super("Dispenser not found", 404)
      end
    end
  end
end
