# frozen_string_literal: true

# This is a wrapper/serializer for Faraday's responses
class Response
  attr_reader :body, :status

  def initialize(faraday_response)
    @response = faraday_response
    @body     = parse_body
    @status   = faraday_response.status

    log
  end

  def success?
    @response.success?
  end

  private

  def log
    return unless Rails.env.development?

    Rails.logger.tagged('Response') { Rails.logger.debug(@body) }
  end

  def parse_body
    parsed_body = JSON.parse(@response.body)

    if parsed_body.instance_of?(Hash)
      parsed_body.deep_symbolize_keys
    elsif parsed_body.instance_of?(Array)
      parsed_body.map(&:deep_symbolize_keys)
    end
  rescue JSON::ParserError
    @response.body
  end
end
