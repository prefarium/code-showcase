# frozen_string_literal: true

module Landing
  class MemberSerializer < BaseSerializer
    identifier :id

    field :name
    field :position
    field :quote
    field :text

    field :avatar do |member|
      blob_url_for member.avatar
    end
  end
end
