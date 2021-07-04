# frozen_string_literal: true

module Admin
  module Landing
    class MembersController < Admin::ApplicationController
      private

      def default_sorting_attribute
        :name
      end

      def default_sorting_direction
        :asc
      end
    end
  end
end
