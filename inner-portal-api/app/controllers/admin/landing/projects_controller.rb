# frozen_string_literal: true

module Admin
  module Landing
    class ProjectsController < Admin::ApplicationController
      private

      def default_sorting_attribute
        :order_number
      end

      def default_sorting_direction
        :asc
      end
    end
  end
end
