module ApiException
  class ContainerError < ApiException::BaseException
    class EventMismatch < ApiException::ContainerError
      def initialize
        super("Order cannot be picked up from this container as it was made in a different event", 404)
      end
    end
  end
end
