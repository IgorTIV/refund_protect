require 'rest-client'

module RefundProtect
  module BaseRequest

    def send_data
      if RefundProtect::Config.disabled?
         RefundProtect::Config.logger_instance.info("RefundProtect:REQUEST => Disabled")
        return
      end

      options = {
        method: method,
        url: url,
        payload: payload.to_json,
        headers: headers,
        timeout: RefundProtect::Config.timeout
      }

      RefundProtect::Config.logger_instance.info("RefundProtect:REQUEST #{options}")

      response = RestClient::Request.execute(options)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end

    def url
      "#{RefundProtect::Config.host}/#{path}"
    end

    def path
      raise NotImplementedError
    end

    def method
      raise NotImplementedError
    end

    def headers
      {
        :content_type => :json,
        :accept => :json,
        :'X-RefundProtect-VendorId' => RefundProtect::Config.vendor_id,
        :'X-RefundProtect-AuthToken' => RefundProtect::Config.auth_token
      }
    end
  end
end
