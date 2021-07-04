# frozen_string_literal: true

class UserSerializer < BaseSerializer
  identifier :id

  view :base do
    include_view :avatar
    include_view :full_name

    association :division, blueprint: DivisionSerializer
    association :position, blueprint: PositionSerializer

    field :actual_position
    field :email
    field :phone
    field :show_crown do |user| # rubocop:disable Style/SymbolProc
      user.boss?
    end
  end

  view :index do
    include_view :base
  end

  view :show do
    include_view :base

    field :birth_date, datetime_format: '%d.%m.%Y'
    field :role
  end

  view :show_for_current_user do
    include_view :show

    association :telegram_account, blueprint: TelegramAccountSerializer
    association :notification_setting, blueprint: NotificationSettingSerializer
  end

  view :avatar do
    field :avatar do |user|
      user.avatar.attached? ? blob_url_for(user.avatar) : nil
    end
  end

  view :birthday do
    include_view :avatar
    include_view :last_and_first_names

    association :position, blueprint: PositionSerializer
    field :actual_position
    field(:birth_date, datetime_format: '%d.%m.%Y')
  end

  view :data_for_caching do
    include_view :avatar

    field :actual_position
    field :first_name
    field :last_name
    field :middle_name
    field :role
  end

  view :full_name do
    field :full_name, name: :name
  end

  view :last_and_first_names do
    field :last_and_first_names, name: :name
  end

  view :short_name do
    field :short_name, name: :name
  end

  view :short_name_with_avatar do
    include_view :avatar
    include_view :short_name
  end
end
