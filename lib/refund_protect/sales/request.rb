require "refund_protect/base_request"
require "refund_protect/sales/validations"
require "refund_protect/sales/product"

module RefundProtect
  module Sales
    ATTRIBUTES ||= %i[
      sales_reference_id
      sales_date
      customer_first_name
      customer_last_name
      products_attrs
    ].freeze

    Request = Struct.new(*ATTRIBUTES, keyword_init: true) do
      include BaseRequest
      include Validations

      def method
        :post
      end

      def path
        'salesoffering'
      end

      def payload
        {
          'vendorCode': RefundProtect::Config.vendor_id,
          'vendorSalesReferenceId': sales_reference_id,
          'VendorSalesDate': sales_date_format,
          'customerFirstName': customer_first_name,
          'customerLastName': customer_last_name,
          'products': products.map(&:payload)
        }
      end

      def products
        attributes = products_attrs.is_a?(Array) ? products_attrs : []

        @products ||= attributes.map do |attrs|
          Product.new(attrs)
        end
      end

      def sales_date
        self[:sales_date] = DateTime.parse(self[:sales_date])
      rescue Date::Error, TypeError
        self[:sales_date]
      end

      def sales_date_format
        sales_date.respond_to?(:strftime) ? sales_date.strftime('%Y-%m-%dT%H:%M:%S.%L%z') : sales_date
      end
    end
  end
end
