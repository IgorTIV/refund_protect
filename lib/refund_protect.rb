require "refund_protect/version"
require "refund_protect/config"
require "refund_protect/service"

module RefundProtect
  class << self
    def config
      yield Config
    end

    def sales(attributes)
      attributes.slice!(*Sales::ATTRIBUTES)

      if attributes[:products_attrs].respond_to?(:each)
        attributes[:products_attrs].each { |attrs| attrs.slice!(*Sales::PRODUCT_ATTRIBUTES) }
      end

      Service.new(:sales, attributes).process
    end

    def cancellation(attributes)
      Service.new(:cancellation, attributes.slice(*Cancellation::ATTRIBUTES)).process
    end
  end
end
