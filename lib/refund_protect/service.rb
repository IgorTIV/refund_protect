require "refund_protect/exceptions"
require "refund_protect/sales/request"
require "refund_protect/sales/response"
require "refund_protect/cancellation/request"
require "refund_protect/cancellation/response"

module RefundProtect
  class Service
    attr_reader :data, :action, :raise_errors

    def initialize(action, data, raise_errors: false)
      @action = action
      @data = data
      @raise_errors = raise_errors
    end

    def process
      request.valid? ? response : invalid_request
    end

    private

    def request
      @request ||= "RefundProtect::#{action.capitalize}::Request".constantize.new(data)
    end

    def response
      @response ||= begin
        result = request.send_data

        "RefundProtect::#{action.capitalize}::Response".constantize.new(result).process.yield_self do |r|
          return r unless raise_errors

          r[:success] ? r : (raise RefundProtect::ResponseInvalid.new(r))
        end
      end
    end

    def invalid_request
      raise_errors ? (raise RefundProtect::RequestInvalid.new(request.errors)) : { errors: request.errors }
    end
  end
end
