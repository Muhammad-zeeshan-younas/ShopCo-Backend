module ApiException
  class SelectedGroupOrderItemError < ApiException::BaseException
    class SelectedItemNotFound < ApiException::SelectedGroupOrderItemError
      def initialize
        super("Selected item not found", 400)
      end
    end
  end
end
