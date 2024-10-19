module ApiException
  class OrderError < ApiException::BaseException
    class NotEnoughCredits < ApiException::OrderError
      def initialize
        super("Not enough credits", 400)
      end
    end
  end
end
