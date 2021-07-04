# frozen_string_literal: true

# This is a wrapper for any request to an external API
# It uses Faraday gem for sending requests
class Request
  attr_accessor :provider_name, :url, :body, :headers

  def initialize(**request_params)
    # It may receive a hash such as:
    #   > { url: 'https://reddit.com', body: { login: admin, password: qwerty123 } }
    # Based on the hash's keys the following instance variables will be created:
    #   > @url  # => 'https://reddit.com'
    #   > @body # => { login: admin, password: qwerty123 }
    request_params.each_pair { |key, val| instance_variable_set("@#{key}", val) }
  end

  def get
    faraday_response = Faraday.get(@url, @body, @headers)

    log

    Response.new(faraday_response)
  end

  def post
    faraday_response = Faraday.post(@url, @body.to_json, @headers)

    log

    Response.new(faraday_response)
  end

  private

  def log
    return unless Rails.env.development?

    Rails.logger.tagged('Request') do
      Rails.logger.debug(@url)
      Rails.logger.debug(@body)
    end
  end
end
