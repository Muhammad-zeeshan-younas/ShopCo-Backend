module ApiException
    class GroupOrderError < ApiException::BaseException
      class AlreadyPicked < ApiException::GroupOrderError
        def initialize
          super("Group Order already picked", 400)
        end
      end
    end
  end
  