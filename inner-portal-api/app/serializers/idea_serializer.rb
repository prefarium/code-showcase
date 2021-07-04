# frozen_string_literal: true

class IdeaSerializer < BaseSerializer
  identifier :id

  view :base do
    include_view :votes

    association :author, blueprint: UserSerializer, view: :short_name
    association :division, blueprint: DivisionSerializer

    field :end_date, datetime_format: '%d.%m.%Y'
    field :status
    field :title
  end

  view :index do
    include_view :base
    include_view :pin
  end

  view :show do
    include_view :base
    include_view :pin

    association :author, blueprint: UserSerializer, view: :short_name_with_avatar

    field :description
  end

  view :aside_block do
    include_view :base
    exclude :author
    exclude :vote
  end

  view :search do
    include_view :base
    include_view :pin
    exclude :vote
  end

  view :pin do
    field(:pinned) do |idea, options|
      Pin.find_by(idea: idea, pinner: options[:user]).present?
    end
  end

  view :votes do
    field :dislikes do |idea|
      idea.get_dislikes.size
    end

    field :likes do |idea|
      idea.get_likes.size
    end

    field :vote do |idea, options|
      options[:user].voting_result_for(idea)
    end
  end
end
