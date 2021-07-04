# frozen_string_literal: true

module TextRandomizer
  EMAIL_BUTTONS = [
    'Перейти',
    'Вот, собственно, кнопка',
    'Вперёд, на сайт!',
    '-> жмите сюда <-'
  ].freeze

  def self.email_button
    EMAIL_BUTTONS.sample
  end
end
