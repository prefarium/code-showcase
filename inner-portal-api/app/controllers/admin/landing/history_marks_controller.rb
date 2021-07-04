# frozen_string_literal: true

module Admin
  module Landing
    class HistoryMarksController < Admin::ApplicationController
      private

      def default_sorting_attribute
        :year
      end

      def default_sorting_direction
        :asc
      end
    end
  end
end
