require "refund_protect/base_validations"

module RefundProtect
  module Sales
    module Validations
      include BaseValidations

      def run_validations
        validates_presence_of(:sales_reference_id)
        validates_presence_of(:customer_first_name)
        validates_presence_of(:customer_last_name)
        validates_object_class_of(:sales_date, DateTime)
        validates_nested_array_of(:products)
      end
    end
  end
end
