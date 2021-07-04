# frozen_string_literal: true

module CustomExceptions
  class ProviderNotReached < StandardError
    def initialize(log_tag, request, response)
      exception_message = 'Unexpected response status code from an external API'

      Rails.logger.tagged(log_tag) do
        Rails.logger.fatal exception_message
        Rails.logger.fatal "Provider name: #{request.provider_name}"
        Rails.logger.fatal "URL: #{request.url}"
        Rails.logger.fatal "Request body: #{request.body}"
        Rails.logger.fatal "Response body: #{response.body}"
        Rails.logger.fatal "Response status: #{response.status}"
      end

      super(exception_message)
    end
  end
end
