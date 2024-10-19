module ApiException
  class UnitError < ApiException::BaseException
    class UnitNotFound < ApiException::UnitError
      def initialize
        super("Unit not found", 404)
      end
    end
  end
end
