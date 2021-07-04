# frozen_string_literal: true

class PasswordMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail to: user.email, subject: 'Внутренний портал'
  end

  def restore_password_email(user)
    @token = user.reset_token
    mail to: user.email, subject: 'Сброс пароля на внутреннем портале'
  end
end
