module ApiException
  class EventError < ApiException::BaseException
    class EventJoiningNotOpenYet < ApiException::EventError
      def initialize
        super("Event joining is not open yet", 400)
      end
    end
  end
end
