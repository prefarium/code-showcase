# frozen_string_literal: true

module Landing
  class GroupBind < ApplicationRecord
    belongs_to :competence,
               class_name:  'Landing::Competence',
               foreign_key: :landing_competence_id,
               inverse_of:  :group_binds

    belongs_to :project_group,
               class_name:  'Landing::ProjectGroup',
               foreign_key: :landing_project_group_id,
               inverse_of:  :group_binds
  end
end
