# frozen_string_literal: true

module Landing
  class Bind < ApplicationRecord
    belongs_to :competence,
               class_name:  'Landing::Competence',
               foreign_key: :landing_competence_id,
               inverse_of:  :binds

    belongs_to :project,
               class_name:  'Landing::Project',
               foreign_key: :landing_project_id,
               inverse_of:  :binds
  end
end
