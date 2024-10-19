module ApiException
  class EventError < ApiException::BaseException
    class UserAlreadyJoined < ApiException::EventError
      def initialize
        super("User already joined", 400)
      end
    end
  end
end
