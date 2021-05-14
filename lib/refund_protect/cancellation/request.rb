require "refund_protect/base_request"
require "refund_protect/cancellation/validations"

module RefundProtect
  module Cancellation
    ATTRIBUTES ||= %i[
      sales_reference_id
    ].freeze

    Request = Struct.new(*ATTRIBUTES, keyword_init: true) do
      include BaseRequest
      include Validations

      def method
        :delete
      end

      def path
        sales_reference_id
      end

      def payload
        {}
      end
    end
  end
end
