# frozen_string_literal: true

class MessageDelivery < ActionMailer::MessageDelivery
  # Гем letter_opener открывает письма в браузере только при использовании метода deliver_now,
  #   поэтому в среде разработки все письма должны отправляться через deliver_now
  def deliver_later
    Rails.env.development? ? deliver_now : super
  end
end
