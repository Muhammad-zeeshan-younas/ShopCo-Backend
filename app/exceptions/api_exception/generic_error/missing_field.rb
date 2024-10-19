module ApiException
  class GenericError < ApiException::BaseException
    class MissingField < ApiException::GenericError
      def initialize(field)
        super("The following field is missing #{field}", 400)
      end
    end
  end
end
