module ApiException
  class GroupError < ApiException::BaseException
    class AtLeastOneAdmin < ApiException::EventError
      def initialize
        super("Make somebody else Admin before leaving the group.", 400)
      end
    end
  end
end
