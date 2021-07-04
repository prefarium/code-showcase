# frozen_string_literal: true

class EventSerializer < BaseSerializer
  identifier :id

  view :base do
    association :author, blueprint: UserSerializer, view: :short_name_with_avatar

    field :end_time, datetime_format: '%d.%m.%Y %H:%M'
    field :start_time, datetime_format: '%d.%m.%Y %H:%M'
    field :status

    field :thumb do |event, options|
      thumb(event, options[:current_user])
    end

    field :title do |event|
      event.title || Event.human_attribute_name("type.#{event.type}")
    end

    field :deletable do |event, options|
      options[:current_user]&.id == event.author_id && (event.pending? || event.status.nil?)
    end
  end

  view :index do
    include_view :base
  end

  view :for_notification_center do
    include_view :base
    exclude :deletable
    field :description
  end

  view :show do
    include_view :base

    field :description

    field :participants do |event|
      UserSerializer.render_as_hash(event.participants.with_attached_avatar, view: :short_name_with_avatar)
    end

    field :canceled do |event| # rubocop:disable Style/SymbolProc
      event.canceled?
    end
  end

  class << self
    private

    def thumb(event, user)
      Event::STATUSES_TO_THUMBS[event.status] if event.confirmable? && user.boss_of?(event.author)
    end
  end
end
