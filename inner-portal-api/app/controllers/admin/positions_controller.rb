# frozen_string_literal: true

module Admin
  class PositionsController < Admin::ApplicationController
    private

    def default_sorting_attribute
      :name
    end

    def default_sorting_direction
      :asc
    end
  end
end
