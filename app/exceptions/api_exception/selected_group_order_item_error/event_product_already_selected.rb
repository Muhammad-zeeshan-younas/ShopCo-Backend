module ApiException
  class SelectedGroupOrderItemError < ApiException::BaseException
    class EventProductAlreadySelected < ApiException::SelectedGroupOrderItemError
      def initialize
        super("Event product already selected", 400)
      end
    end
  end
end
