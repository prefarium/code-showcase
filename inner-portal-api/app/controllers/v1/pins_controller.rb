# frozen_string_literal: true

module V1
  class PinsController < APIController
    before_action :set_idea

    def create
      return render_error(I18n.t('errors.ideas.cannot_pin'), :forbidden) unless IdeaPolicy.can(current_user).pin?(@idea)

      context = Idea::PinOne.call(idea: @idea, pinner: current_user)

      render_error_from_context(context) if context.failure?
    end

    def destroy
      context = Idea::Unpin.call(idea: @idea, pinner: current_user)

      render_error_from_context(context) if context.failure?
    end

    private

    def set_idea
      @idea = Idea.find(params[:id])
    end
  end
end
