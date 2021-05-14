module RefundProtect
  module Config
    DEFAULT_HOST = 'https://test.api.protectgroup.co/api/v1/refundprotect'
    TIMEOUT_IN_SECONDS = 10

    class << self
      attr_accessor :vendor_id, :auth_token

      attr_writer :host, :timeout, :logger_instance, :disable_real_requests

      def host
        @host ||= DEFAULT_HOST
      end

      def timeout
        @timeout ||= TIMEOUT_IN_SECONDS
      end

      def logger_instance
        @logger_instance ||= Logger.new(STDOUT)
      end

      def disable_real_requests
        @disable_real_requests ||= false
      end
    end
  end
end
