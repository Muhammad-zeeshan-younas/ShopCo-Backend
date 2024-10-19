module ApiException
  class GroupError < ApiException::BaseException
    class UserNotGroupAdmin < ApiException::GroupError
      def initialize
        super("Only group admins can perform this action", 400)
      end
    end
  end
end
