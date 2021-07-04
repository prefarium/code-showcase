# frozen_string_literal: true

module Ideas
  class EndVotingJob < ApplicationJob
    queue_as :default

    def perform
      ideas = Idea.active.where('end_date <= ?', Date.current)

      ideas.each do |idea|
        context = Idea::EndVoting.call(
          idea:        idea,
          idea_params: { status: idea.total_likes > idea.total_dislikes ? :approved : :denied }
        )

        raise StandardError, context.error_message if context.failure?
      end
    end
  end
end
