require "refund_protect/base_validations"

module RefundProtect
  module Sales
    PRODUCT_ATTRIBUTES ||= %i[
      product_code
      currency_code
      product_price
      permium_rate
      offering_method
      sold
      insurance_end_date
    ].freeze

    Product = Struct.new(*PRODUCT_ATTRIBUTES, keyword_init: true) do
      include BaseValidations

      def payload
        {
          'productCode': product_code,
          'currencyCode':  currency_code,
          'productPrice': product_price,
          'premiumRate': permium_rate,
          'offeringMethod': offering_method,
          'sold': sold == 'Y',
          'insuranceEndDate': insurance_end_date_format
        }
      end

      def insurance_end_date
        self[:insurance_end_date] = DateTime.parse(self[:insurance_end_date])
      rescue Date::Error, TypeError
        self[:insurance_end_date]
      end

      def product_price
        self[:product_price] = Float(self[:product_price])
      rescue
        self[:product_price]
      end

      def permium_rate
        self[:permium_rate] = Float(self[:permium_rate])
      rescue
        self[:permium_rate]
      end

      def insurance_end_date_format
        insurance_end_date.respond_to?(:strftime) ? insurance_end_date.strftime('%Y-%m-%dT%H:%M:%S.%L%z') : insurance_end_date
      end

      def run_validations
        validates_inclusion_in(:product_code, %w[TKT PKG HTL])
        validates_presence_of(:currency_code)
        validates_object_class_of(:product_price, Numeric)
        validates_inclusion_in(:sold, %w[Y N]) unless sold
        validates_object_class_of(:permium_rate, Numeric)
        validates_inclusion_in(:offering_method, %w[OPT-IN OPT-OUT])
        validates_object_class_of(:insurance_end_date, DateTime)
      end
    end
  end
end
