module ApiException
  class SelectedGroupOrderItemError < ApiException::BaseException
    class EventProductNotFound < ApiException::SelectedGroupOrderItemError
      def initialize
        super("Event product not found", 400)
      end
    end
  end
end
