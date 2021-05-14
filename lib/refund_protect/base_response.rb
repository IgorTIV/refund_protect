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

      RefundProtect::Config.logger_instance.info("RefundProtect:RESPONSE Code: #{code}, Body: #{body}")
    end

    def process
      error('Invalid response') unless response.is_a?(RestClient::Response) && !parsed_body.nil?

      if code.in?(SUCCESS_RESPONSE_CODES) && parsed_body.casecmp?(SUCCESS_RESPONSE_BODY)
        { success: true }
      elsif parsed_body.is_a?(Hash)
        parsed_body.merge(success: false)
      else
        error("Invalid response: #{parsed_body}")
      end
    end

    private

    def error(message)
      { errors: [message], success: false }
    end

    def parsed_body
      @parsed_body ||= JSON.parse(response.body)
    rescue JSON::ParserError
      nil
    end
  end
end
