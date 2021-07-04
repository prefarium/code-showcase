# frozen_string_literal: true

module Landing
  class Project < ApplicationRecord
    belongs_to :project_group,
               class_name:  'Landing::ProjectGroup',
               foreign_key: :landing_project_group_id,
               inverse_of:  :projects,
               optional:    true

    has_one_attached :cover

    has_many :binds,
             class_name:  'Landing::Bind',
             foreign_key: :landing_project_id,
             inverse_of:  :project,
             dependent:   :destroy

    has_many :competences, class_name: 'Landing::Competence', through: :binds

    validates :title, :subtitle, :text_on_cover, :text, presence: true
  end
end
