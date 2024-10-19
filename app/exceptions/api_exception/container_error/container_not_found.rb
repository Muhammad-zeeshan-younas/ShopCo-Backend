module ApiException
  class ContainerError < ApiException::BaseException
    class ContainerNotFound < ApiException::ContainerError
      def initialize
        super("Container not found", 404)
      end
    end
  end
end
