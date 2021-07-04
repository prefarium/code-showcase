# frozen_string_literal: true

module Landing
  class ProjectSerializer < BaseSerializer
    identifier :id

    field :title
    field :subtitle
    field :text_on_cover
    field :text

    field :cover do |project|
      blob_url_for project.cover
    end

    field :competence_icons do |project|
      project.competences.map { |competence| blob_url_for competence.icon }
    end
  end
end
