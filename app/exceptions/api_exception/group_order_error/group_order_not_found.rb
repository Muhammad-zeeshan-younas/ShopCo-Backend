module ApiException
  class GroupOrderError < ApiException::BaseException
    class GroupOrderNotFound < ApiException::GroupOrderError
      def initialize
        super("Group Order not found", 404)
      end
    end
  end
end
