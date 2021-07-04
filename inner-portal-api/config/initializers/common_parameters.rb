# frozen_string_literal: true

I18n.config.available_locales = %i[ru en]
# I18n.default_locale = Rails.env.production? ? :ru : :en
I18n.default_locale = :ru
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'attributes', '*.{rb,yml}')]
