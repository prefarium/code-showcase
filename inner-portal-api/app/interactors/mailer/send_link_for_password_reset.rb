# frozen_string_literal: true

module Mailer
  class SendLinkForPasswordReset
    include Interactor

    def call
      user = context.user

      PasswordMailer.restore_password_email(user).deliver_later
    end
  end
end
