require "refund_protect/version"
require "refund_protect/config"
require "refund_protect/service"

module RefundProtect
  class << self
    def config
      yield Config
    end

    def sales(attributes)
      run_sales(attributes, raise_errors: false)
    end

    def sales!(attributes)
      run_sales(attributes, raise_errors: true)
    end

    def cancellation(attributes)
      run_cancellation(attributes, raise_errors: false)
    end

    def cancellation!(attributes)
      run_cancellation(attributes, raise_errors: true)
    end

    private

    def run_sales(attributes, raise_errors:)
      attributes.slice!(*Sales::ATTRIBUTES)

      if attributes[:products_attrs].respond_to?(:each)
        attributes[:products_attrs].each { |attrs| attrs.slice!(*Sales::PRODUCT_ATTRIBUTES) }
      end

      Service.new(:sales, attributes, raise_errors: raise_errors).process
    end

    def run_cancellation(attributes, raise_errors:)
      Service.new(:cancellation, attributes.slice(*Cancellation::ATTRIBUTES), raise_errors: raise_errors).process
    end
  end
end
