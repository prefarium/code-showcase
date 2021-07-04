# frozen_string_literal: true

class Control
  class Create
    include Interactor

    def call
      user                               = context.user
      context.divisions_to_be_controlled = context.divisions_to_be_controlled - user.controlled_divisions

      context.divisions_to_be_controlled.each { |division| user.controlled_divisions << division }
    end

    def rollback
      context.divisions_to_be_controlled.each do |division|
        Control.find_by(division: division, manager: context.user)&.destroy
      end
    end
  end
end
