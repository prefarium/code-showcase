# frozen_string_literal: true

module Landing
  class ProjectGroupSerializer < BaseSerializer
    identifier :id

    field :title
    field :subtitle
    field :text_on_cover

    field :cover do |project_group|
      blob_url_for project_group.cover
    end

    field :competence_icons do |project_group|
      project_group.competences.map { |competence| blob_url_for competence.icon }
    end
  end
end
