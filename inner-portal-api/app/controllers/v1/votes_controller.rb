# frozen_string_literal: true

module V1
  class VotesController < APIController
    before_action :set_idea, only: :update

    def update
      unless IdeaPolicy.can(current_user).vote?(@idea)
        return render_error(I18n.t('errors.ideas.cannot_vote'), :forbidden)
      end

      context = Idea::Vote.call(vote_params: vote_params, idea: @idea, user: current_user)

      render_error_from_context(context) if context.failure?
    end

    private

    def set_idea
      @idea = Idea.find(params[:id])
    end

    def vote_params
      permit_params(:vote)
    end
  end
end
