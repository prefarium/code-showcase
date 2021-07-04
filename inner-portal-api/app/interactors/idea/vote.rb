# frozen_string_literal: true

class Idea
  class Vote
    include Interactor

    def call
      user   = context.user
      idea   = context.idea
      params = context.vote_params

      case params[:vote]
      when 'like'
        if user.liked?(idea)
          context.fail!(error_message: I18n.t('errors.ideas.already_liked'), error_status: :forbidden)
        end

        user.likes(idea)

      when 'dislike'
        if user.disliked?(idea)
          context.fail!(error_message: I18n.t('errors.ideas.already_disliked'), error_status: :forbidden)
        end

        user.dislikes(idea)

      else
        context.fail!(error_message: I18n.t('errors.ideas.unprocessable_vote'), error_status: :unprocessable_entity)
      end
    end
  end
end
