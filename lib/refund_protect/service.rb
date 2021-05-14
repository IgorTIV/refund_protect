require "refund_protect/sales/request"
require "refund_protect/sales/response"
require "refund_protect/cancellation/request"
require "refund_protect/cancellation/response"

module RefundProtect
  class Service
    attr_reader :data, :action

    def initialize(action, data)
      @action = action
      @data = data
    end

    def process
      request.valid? ? response : { errors: request.errors }
    end

    private

    def request
      @request ||= "RefundProtect::#{action.capitalize}::Request".constantize.new(data)
    end

    def response
      @response ||= begin
        result = request.send_data

        "RefundProtect::#{action.capitalize}::Response".constantize.new(result).process
      end
    end
  end
end
