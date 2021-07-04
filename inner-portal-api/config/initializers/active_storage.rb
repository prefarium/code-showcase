# frozen_string_literal: true

Rails.application.routes.default_url_options[:host] = Rails.env.production? ? '__deleted__' : 'localhost:3000'
