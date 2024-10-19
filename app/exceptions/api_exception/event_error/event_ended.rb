module ApiException
  class EventError < ApiException::BaseException
    class EventEnded < ApiException::EventError
      def initialize
        super("Event has been ended", 400)
      end
    end
  end
end
