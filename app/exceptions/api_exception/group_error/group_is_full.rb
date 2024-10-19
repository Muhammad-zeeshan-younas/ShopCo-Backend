module ApiException
  class GroupError < ApiException::BaseException
    class GroupIsFull < ApiException::GroupError
      def initialize
        super("Group is already full", 400)
      end
    end
  end
end
