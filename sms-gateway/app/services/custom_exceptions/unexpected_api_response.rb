# frozen_string_literal: true

module CustomExceptions
  class UnexpectedApiResponse < StandardError
    def initialize(log_tag, request, response)
      exception_message = 'Unexpected API response when HTTP response is successful'

      Rails.logger.tagged(log_tag) do
        Rails.logger.fatal exception_message
        Rails.logger.fatal "Provider name: #{request.provider_name}"
        Rails.logger.fatal "URL: #{request.url}"
        Rails.logger.fatal "Request body: #{request.body}"
        Rails.logger.fatal "Response body: #{response.body}"
      end

      super(exception_message)
    end
  end
end
