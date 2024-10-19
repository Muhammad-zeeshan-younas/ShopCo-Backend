module ApiException
  class GroupError < ApiException::BaseException
    class GroupNotFound < ApiException::GroupError
      def initialize
        super("Group not found", 404)
      end
    end
  end
end
