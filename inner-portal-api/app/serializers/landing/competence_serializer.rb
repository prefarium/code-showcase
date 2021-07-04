# frozen_string_literal: true

module Landing
  class CompetenceSerializer < BaseSerializer
    identifier :id

    field :title
    field :text

    field :icon do |competence|
      blob_url_for(competence.icon)
    end

    field :image do |competence|
      blob_url_for(competence.image)
    end
  end
end
