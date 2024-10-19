module ApiException
  class PosError < ApiException::BaseException
    class DeviceNotFound < ApiException::PosError
      def initialize
        super("Device is not found", 404)
      end
    end
  end
end
