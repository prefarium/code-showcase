# frozen_string_literal: true

require 'faker'

beginning_of_time      = Time.zone.parse('01.01.2020')
not_updatable_statuses = %i[undefined error failed expired rejected unknown]
operators              = %i[mts mts mts mts mts beeline beeline beeline megafon megafon tele2 yota]

def random_time(from = '01.01.2020', to = Time.zone.now)
  date1 = Time.zone.parse(from.to_s)
  date2 = Time.zone.parse(to.to_s)
  Time.zone.at((Float(date2) - Float(date1)) * rand + Float(date1))
end

Admin.create!(
  email:      'admin@example.com',
  password:   'qwerty123',
  created_at: beginning_of_time
)

tera_sms = Provider.create!(
  login:               'login',
  password:            'this_one_is_incorrect',
  name:                'TeraSms',
  token:               'incorrect_too',
  default_sender_name: 'terasms.ru',
  created_at:          beginning_of_time
)

sms_center = Provider.create!(
  login:               'login',
  password:            'this_one_is_incorrect',
  name:                'SmsCenter',
  default_sender_name: 'SMSC.RU',
  created_at:          random_time('01.01.2020', '01.02.2020')
)

beeline = Provider.create!(
  login:               'login',
  password:            'this_one_is_incorrect',
  name:                'Beeline',
  default_sender_name: 'Beeline',
  created_at:          random_time('01.01.2020', '01.02.2020')
)

system = User.create!(
  name:       'Система',
  created_at: beginning_of_time
)

Key.create!(
  user:        system,
  provider:    tera_sms,
  sender_name: 'terasms.ru',
  created_at:  system.created_at
)

first_user = User.create!(
  name:       'Первый пользователь',
  created_at: random_time(sms_center.created_at)
)

Key.create!(
  user:       first_user,
  provider:   sms_center,
  created_at: first_user.created_at
)

user_names = [
  'Второй пользователь',
  'Третий пользователь',
  'Четвертый пользователь'
]

sender_names = [
  'Второй пользователь',
  'Третий пользователь',
  'Четвертый пользователь'
]

users = user_names.map { |name| User.create!(name: name, created_at: random_time('01.03.2020')) }

users.each_with_index do |user, idx|
  Key.create!(
    user:        user,
    provider:    tera_sms,
    sender_name: sender_names[idx],
    created_at:  user.created_at
  )
end

Key.create!(
  user:        users.last,
  provider:    sms_center,
  sender_name: sender_names.last,
  created_at:  random_time(users.last.created_at)
)

Key.create!(
  user:        users.last,
  provider:    beeline,
  sender_name: sender_names.last,
  created_at:  random_time(users.last.created_at)
)

Key.create!(
  user:        users.third,
  provider:    beeline,
  sender_name: 'Пользователь',
  created_at:  random_time(users.third.created_at)
)

Key.create!(
  user:        users.first,
  provider:    sms_center,
  sender_name: sms_center.default_sender_name,
  created_at:  random_time(users.first.created_at)
)

Key.all.each do |key|
  rand(80..150).times do
    Message.create(
      user:       key.user,
      provider:   key.provider,
      content:    Faker::ChuckNorris.fact,
      cost:       (rand * 10).round(2),
      target:     "79#{rand(000_000_000..999_999_999)}",
      status:     :delivered,
      operator:   operators.sample,
      created_at: random_time(key.user.created_at)
    )
  end
end

random_messages = Message.limit(50).order('RANDOM()')
random_messages.each { |msg| msg.update!(status: not_updatable_statuses.sample) }
