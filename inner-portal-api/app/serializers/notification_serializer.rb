# frozen_string_literal: true

class NotificationSerializer < BaseSerializer
  identifier :id
  field :read
  field :title
  field :body
  field :link
  field :notifiable_type
end
