# frozen_string_literal: true

class NewsSerializer < BaseSerializer
  identifier :id

  view :base do
    field :body
    field :date, datetime_format: '%d.%m.%Y'
    field :title
  end

  view :index do
    include_view :base
  end

  view :show do
    include_view :base

    field :status
    field :image do |news|
      news.image.attached? ? blob_url_for(news.image) : nil
    end
  end

  view :aside_block do
    field :body
  end
end
