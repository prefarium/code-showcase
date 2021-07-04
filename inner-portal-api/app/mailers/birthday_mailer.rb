# frozen_string_literal: true

class BirthdayMailer < ApplicationMailer
  def invite(user_id, birthday_man_id, link)
    @user         = User.find(user_id)
    @birthday_man = User.find(birthday_man_id)
    @link         = link

    mail to: @user.email, subject: "#{@birthday_man.first_and_middle_names} скоро будет отмечать день рождения!"
  end
end
