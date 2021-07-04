# frozen_string_literal: true

def attach_avatar(user, path)
  # Блок кода из User::UpdateAvatar
  avatar_image = MiniMagick::Image.open(path)
  new_avatar   = ImageCropper.resize_with_crop(avatar_image,
                                               ENV.fetch('WIDTH', 400).to_i,
                                               ENV.fetch('HEIGHT', 400).to_i)

  File.open(new_avatar.path) do |file|
    filename = "avatar#{Time.current.strftime('%Y%m%d%H%M%S')}"
    user.avatar.attach(io: file, filename: filename)
  end
end

def adjust_birthdays(team)
  today         = Date.current
  datestamp     = Date.new(1970, today.month, today.day)
  first_period  = datestamp..datestamp.end_of_month
  second_period = (datestamp + 1.month).beginning_of_month..(datestamp + 1.month).end_of_month

  team[0..4].each { |guy| guy.update!(birth_date: rand(first_period)) }
  team[5..9].each { |guy| guy.update!(birth_date: rand(second_period)) }
end

password = 'password'

FIRST_NAMES  = %w[Антон Александр Василий Алексей Олег Данил Марк Михаил Никита Илья].freeze
LAST_NAMES   = Array.new(10) { 'Иванов' }.freeze
MIDDLE_NAMES = %w[Николаевич Александрович Игоревич Антонович Алексеевич Романович Андреевич Олегович].freeze

# ----- Web Dev Team

web_dev_team = Division.find_or_create_by!(name: 'Служба веб разработки')

position_names =
  [
    'Технолог I категории',
    'Технолог II категории',
    'Технолог III категории',
    'Архитектор',
    'Разработчик'
  ]

head_position   = Position.find_or_create_by!(name: 'Начальник службы')
expert          = Position.find_or_create_by!(name: 'Эксперт')
other_positions = position_names.map { |position_name| Position.find_or_create_by!(name: position_name) }

head = User.find_or_create_by!(email: 'head@example.com') do |user|
  user.last_name       = 'Егоров'
  user.first_name      = 'Даниил'
  user.middle_name     = 'Михайлович'
  user.phone           = 9_999_999_999.to_s
  user.division        = web_dev_team
  user.paper_division  = web_dev_team
  user.position        = head_position
  user.actual_position = 'Руководитель службы веб разработки'
  user.birth_date      = '07.02.1970'
  user.role            = :head
  user.password        = password
end

Dashboard.create!(user: head) unless head.dashboard
NotificationSetting.create!(user: head, email: false) unless head.notification_setting

attach_avatar(head, Rails.root.join('lib/avatars/0.jpg')) unless head.avatar.attached?

head.controlled_divisions << head.division unless Control.find_by(division: head.division, manager: head)

mortal = User.find_or_create_by!(email: 'mortal@example.com') do |user|
  user.last_name       = 'Крестьянинов'
  user.first_name      = 'Антон'
  user.middle_name     = 'Витальевич'
  user.phone           = 9_888_888_888.to_s
  user.division        = web_dev_team
  user.paper_division  = web_dev_team
  user.position        = expert
  user.actual_position = 'Бэкэнд разработчик'
  user.birth_date      = '31.01.1970'
  user.password        = password
end

Dashboard.create!(user: mortal) unless mortal.dashboard
NotificationSetting.create!(user: mortal, email: false) unless mortal.notification_setting

attach_avatar(mortal, Rails.root.join('lib/avatars/mortal.jpg')) unless mortal.avatar.attached?

first_names  = FIRST_NAMES.dup.shuffle
last_names   = LAST_NAMES.dup.shuffle
middle_names = MIDDLE_NAMES.dup.shuffle

some_more_guys_in_web_dev_team = []

10.times do |n|
  guy = User.find_or_create_by!(email: "mortal#{n}@example.com") do |user|
    user.first_name      = first_names.pop
    user.last_name       = last_names.pop
    user.middle_name     = middle_names.pop
    user.phone           = "9#{n.to_s.rjust(9, '0')}"
    user.division        = web_dev_team
    user.paper_division  = web_dev_team
    user.position        = other_positions.sample
    user.actual_position = [other_positions.sample.name, nil].sample
    user.birth_date      = '31.01.1970'
    user.password        = password
  end

  Dashboard.create!(user: guy) unless guy.dashboard
  NotificationSetting.create!(user: guy, email: false) unless guy.notification_setting

  attach_avatar(guy, Rails.root.join("lib/avatars/#{n}.jpg")) unless guy.avatar.attached?

  some_more_guys_in_web_dev_team << guy
end

adjust_birthdays(some_more_guys_in_web_dev_team)

# ----- Главное подразделение

main_division     = Division.find_or_create_by!(name: 'Главное подразделение')
director_position = Position.find_or_create_by!(name: 'Директор')
deputy_position   = Position.find_or_create_by!(name: 'Заместитель директора')

director = User.find_or_create_by!(email: 'director@example.com') do |user|
  user.last_name       = 'Чернов'
  user.first_name      = 'Максим'
  user.middle_name     = 'Петрович'
  user.phone           = 9_777_777_777.to_s
  user.division        = main_division
  user.paper_division  = main_division
  user.position        = director_position
  user.actual_position = 'Директор'
  user.birth_date      = '07.02.1970'
  user.role            = :director
  user.password        = password
end

Dashboard.create!(user: director) unless director.dashboard
NotificationSetting.create!(user: director, email: false) unless director.notification_setting

attach_avatar(director, Rails.root.join('lib/avatars/0.jpg')) unless director.avatar.attached?

unless Control.find_by(division: director.division, manager: director)
  director.controlled_divisions << director.division
end

director.controlled_divisions << web_dev_team unless Control.find_by(division: web_dev_team, manager: director)

deputy = User.find_or_create_by!(email: 'deputy@example.com') do |user|
  user.last_name       = 'Морской'
  user.first_name      = 'Анатолий'
  user.middle_name     = 'Иванович'
  user.phone           = 9_555_555_555.to_s
  user.division        = main_division
  user.paper_division  = main_division
  user.position        = deputy_position
  user.actual_position = 'Заместитель директора'
  user.birth_date      = '31.01.1970'
  user.role            = :deputy
  user.password        = password
end

Dashboard.create!(user: deputy) unless deputy.dashboard
NotificationSetting.create!(user: deputy, email: false) unless deputy.notification_setting

attach_avatar(deputy, Rails.root.join('lib/avatars/0.jpg')) unless deputy.avatar.attached?

# ----- Служба жёсткой разработки

common_division = Division.find_or_create_by!(name: 'Рядовое подразделение')
tough_team      = Division.find_or_create_by!(name: 'Служба жёсткой разработки')

deputy.controlled_divisions << tough_team unless Control.find_by(division: tough_team, manager: deputy)
deputy.controlled_divisions << common_division unless Control.find_by(division: common_division, manager: deputy)

tough_head = User.find_or_create_by!(email: 'tough_head@example.com') do |user|
  user.last_name       = 'Алдерсон'
  user.first_name      = 'Эллиот'
  user.phone           = 9_444_444_444.to_s
  user.division        = common_division
  user.paper_division  = tough_team
  user.position        = head_position
  user.actual_position = 'Руководитель службы жёсткой разработки'
  user.birth_date      = '07.02.1970'
  user.role            = :head
  user.password        = password
end

Dashboard.create!(user: tough_head) unless tough_head.dashboard
NotificationSetting.create!(user: tough_head, email: false) unless tough_head.notification_setting

attach_avatar(tough_head, Rails.root.join('lib/avatars/tough_head.jpg')) unless tough_head.avatar.attached?

tough_head.controlled_divisions << tough_head.division unless Control.find_by(division: tough_team, manager: tough_head)

director.controlled_divisions << web_dev_team unless Control.find_by(division: tough_team, manager: deputy)

tough_first_names  = FIRST_NAMES.dup.shuffle
tough_last_name    = 'Жёсткий'
tough_middle_names = MIDDLE_NAMES.dup.shuffle

some_more_guys_in_tough_team = []

10.times do |n|
  guy = User.find_or_create_by!(email: "tough_mortal#{n}@example.com") do |user|
    user.first_name      = tough_first_names.pop
    user.last_name       = tough_last_name
    user.middle_name     = tough_middle_names.pop
    user.phone           = "99#{n.to_s.rjust(8, '0')}"
    user.division        = tough_team
    user.paper_division  = [common_division, web_dev_team, tough_team].sample
    user.position        = other_positions.sample
    user.actual_position = [other_positions.sample.name, nil].sample
    user.birth_date      = '31.01.1970'
    user.password        = password
  end

  Dashboard.create!(user: guy) unless guy.dashboard
  NotificationSetting.create!(user: guy, email: false) unless guy.notification_setting

  attach_avatar(guy, Rails.root.join("lib/avatars/#{n}.jpg")) unless guy.avatar.attached?

  some_more_guys_in_tough_team << guy
end

adjust_birthdays(some_more_guys_in_tough_team)
