# frozen_string_literal: true

def error_messages_of(model)
  model.errors.full_messages.join('. ')
end

# Делает так, чтобы ссылки на файлы были по https
def blob_url_for(file)
  Rails.application.routes.url_helpers.rails_blob_url(file)
end
