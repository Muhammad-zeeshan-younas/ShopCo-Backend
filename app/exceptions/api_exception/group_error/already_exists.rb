module ApiException
  class GroupError < ApiException::BaseException
    class AlreadyExists < ApiException::EventError
      def initialize
        super("A group with the same name already exists", 400)
      end
    end
  end
end
