require 'json'
require 'rest-client'

module RefundProtect
  class BaseResponse
    attr_reader :response

    SUCCESS_RESPONSE_CODES = [200, 202].freeze
    SUCCESS_RESPONSE_BODY = 'OK'

    delegate :code, :body, to: :response, allow_nil: true

    def initialize(response)
      @response = response
    end

    def process
      return success_response(true) if RefundProtect::Config.disabled?

      RefundProtect::Config.logger_instance.info("RefundProtect:RESPONSE Code: #{code}, Body: #{body}")

      error('Invalid response') unless response.is_a?(RestClient::Response) && !parsed_body.nil?

      if code.in?(SUCCESS_RESPONSE_CODES) && parsed_body.casecmp?(SUCCESS_RESPONSE_BODY)
        success_response(true)
      elsif parsed_body.is_a?(Hash)
        parsed_body.merge(success_response(false))
      else
        error("Invalid response: #{parsed_body}")
      end
    end

    private

    def error(message)
      { errors: [message] }.merge(success_response(false))
    end

    def parsed_body
      @parsed_body ||= JSON.parse(response.body)
    rescue JSON::ParserError
      nil
    end

    def success_response(status)
      { success: status }
    end
  end
end
