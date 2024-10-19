module ApiException
  class GroupOrderError < ApiException::BaseException
    class NoIndividualOrders < ApiException::GroupOrderError
      def initialize
        super("You can't place a single order as a group.", 400)
      end
    end
  end
end
