# frozen_string_literal: true

class DivisionSerializer < BaseSerializer
  identifier :id

  field :name

  view :with_employees do
    association :employees, blueprint: UserSerializer, view: :full_name
  end
end
