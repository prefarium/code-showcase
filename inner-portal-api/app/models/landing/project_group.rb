# frozen_string_literal: true

module Landing
  class ProjectGroup < ApplicationRecord
    has_many :projects,
             class_name:  'Landing::Project',
             foreign_key: :landing_project_group_id,
             inverse_of:  :project_group,
             dependent:   :nullify

    has_one_attached :cover

    has_many :group_binds,
             class_name:  'Landing::GroupBind',
             foreign_key: :landing_project_group_id,
             inverse_of:  :project_group,
             dependent:   :destroy

    has_many :competences, class_name: 'Landing::Competence', through: :group_binds

    validates :title, :subtitle, :text_on_cover, :cover, presence: true
  end
end
