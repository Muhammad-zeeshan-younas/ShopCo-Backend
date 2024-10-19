module ApiException
  class EventError < ApiException::BaseException
    class EventJoinTimePassed < ApiException::EventError
      def initialize
        super("Event join time has passed", 400)
      end
    end
  end
end
