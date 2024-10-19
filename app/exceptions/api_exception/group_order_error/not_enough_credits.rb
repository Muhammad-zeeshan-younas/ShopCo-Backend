module ApiException
  class GroupOrderError < ApiException::BaseException
    class NotEnoughCredits < ApiException::GroupOrderError
      def initialize
        super("One or more group members don't have enough credits for their order.", 400)
      end
    end
  end
end
