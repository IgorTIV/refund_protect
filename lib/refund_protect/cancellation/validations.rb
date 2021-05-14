require "refund_protect/base_validations"

module RefundProtect
  module Cancellation
    module Validations
      include BaseValidations

      def run_validations
        validates_presence_of(:sales_reference_id)
      end
    end
  end
end
