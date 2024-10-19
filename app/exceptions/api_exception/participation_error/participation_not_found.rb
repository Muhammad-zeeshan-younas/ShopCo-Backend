module ApiException
  class ParticipationError < ApiException::BaseException
    class ParticipationNotFound < ApiException::ParticipationError
      def initialize
        super("You didn't join this event", 400)
      end
    end
  end
end
