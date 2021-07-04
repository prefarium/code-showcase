# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@rzdit.ru'
  layout 'mailer'
end
