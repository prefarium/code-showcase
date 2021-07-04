# frozen_string_literal: true

module Landing
  class Competence < ApplicationRecord
    has_one_attached :icon
    has_one_attached :image

    has_many :group_binds,
             class_name:  'Landing::GroupBind',
             foreign_key: :landing_competence_id,
             inverse_of:  :competence,
             dependent:   :destroy

    has_many :project_groups, class_name: 'Landing::ProjectGroup', through: :group_binds

    has_many :binds,
             class_name:  'Landing::Bind',
             foreign_key: :landing_competence_id,
             inverse_of:  :competence,
             dependent:   :destroy

    has_many :projects, class_name: 'Landing::Project', through: :binds

    validates :icon, :image, :title, :text, presence: true
  end
end
