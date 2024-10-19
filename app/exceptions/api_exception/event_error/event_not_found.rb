module ApiException
  class EventError < ApiException::BaseException
    class EventNotFound < ApiException::EventError
      def initialize
        super("Event not found", 404)
      end
    end
  end
end
