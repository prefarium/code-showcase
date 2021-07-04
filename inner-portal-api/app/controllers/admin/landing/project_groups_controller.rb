# frozen_string_literal: true

module Admin
  module Landing
    class ProjectGroupsController < Admin::ApplicationController
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
