# frozen_string_literal: true

module Admin
  class ControlsController < Admin::ApplicationController
    private

    def default_sorting_attribute
      :division
    end
  end
end
