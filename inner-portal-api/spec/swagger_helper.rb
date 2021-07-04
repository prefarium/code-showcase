# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # ----- Настройка свагера
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => { # rubocop:disable Style/StringHashKeys
      openapi:    '3.0.1',
      info:       {
        title:   'API',
        version: 'v1'
      },
      paths:      {},
      servers:    [
        { url: 'https://__deleted__/api' },
        { url: 'http://localhost:3000' }
      ],
      components: {
        securitySchemes: {
          Bearer:  {
            description: 'Access token',
            type:        :apiKey,
            name:        'Authorization',
            in:          :header
          },
          Refresh: {
            description: 'Refresh token',
            type:        :apiKey,
            name:        'X-Refresh-Token',
            in:          :header
          }
        }
      }
    }
  }

  config.swagger_format = :yaml

  # ----- Хэлперы

  def tokens_for(user)
    SessionGenerator.new(user).login
  end

  def response_json
    parsed = begin
      JSON.parse(response.body)
    rescue JSON::ParserError
      response.body
    end

    symbolize(parsed)
  end

  def symbolize(object)
    case object
    when Hash  then object.deep_symbolize_keys
    when Array then object.map { |el| symbolize(el) }
    else object
    end
  end
end
