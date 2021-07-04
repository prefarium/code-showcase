# frozen_string_literal: true

class User
  class SendWelcomeEmail
    include Interactor

    def call
      PasswordMailer.welcome_email(context.user).deliver_later
    end
  end
end
