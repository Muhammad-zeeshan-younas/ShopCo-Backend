module ApiException
  class BaseException < StandardError
    attr_reader :message, :code

    def initialize(message, code)
      super()
      @message = message
      @code = code
    end
  end
end
