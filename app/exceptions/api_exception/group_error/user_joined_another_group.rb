module ApiException
  class GroupError < ApiException::BaseException
    class UserJoinedAnotherGroup < ApiException::EventError
      def initialize
        super("You already part of another group, please leave that first", 400)
      end
    end
  end
end
