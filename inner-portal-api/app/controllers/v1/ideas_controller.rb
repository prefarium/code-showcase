# frozen_string_literal: true

module V1
  class IdeasController < APIController
    include Pagination
    include Notifiable

    before_action :set_idea, only: :show
    after_action(only: :show) do
      mark_notification_as_read(@idea)
      update_notification_numbers
    end

    def index
      return hide_requested_section unless IdeaPolicy.can(current_user).access?(user)

      ideas = Ideas::FilteredCollectionQuery.call(filtered_collection_options)
      ideas = ideas.includes(:author, :division)

      render json: collection_for_rendering(ideas, view: :index, user: current_user)
    end

    def show
      unless IdeaPolicy.can(current_user).read?(@idea)
        return render_error(I18n.t('errors.ideas.cannot_read'), :forbidden)
      end

      render json: IdeaSerializer.render_as_hash(@idea, view: :show, user: current_user)
    end

    def create
      context = Idea::New.call(idea_params: idea_params)

      render_error_from_context(context) if context.failure?
    end

    def pinned
      ideas = current_user.pinned_ideas.public_send(params[:filter] || :active)
      ideas = ideas.includes(:author, :division)

      render json: collection_for_rendering(ideas, view: :index, user: current_user)
    end

    def aside
      # Сейчас работает так, что закреплёнными могут быть только идеи на голосовании
      # Скоуп active тут использован на всякий случай, если в будущем что-то изменится
      pinned_ideas_ids = current_user.pinned_ideas.active.ids
      ideas            = Idea.where(id: pinned_ideas_ids.sample(3))
      ideas_size       = ideas.count

      if ideas_size < 3
        division_ideas_ids = Idea.active
                                 .where(division_id: current_user.division_id)
                                 .and(Idea.where.not(id: pinned_ideas_ids))
                                 .ids

        ideas = ideas.or(Idea.where(id: division_ideas_ids.sample(3 - ideas_size)))
      end

      render json: IdeaSerializer.render_as_hash(ideas, view: :aside_block)
    end

    def search
      ideas = current_user.division.ideas.search(search_query).pg_search_distinct

      render json: collection_for_rendering(ideas, view: :search, user: current_user)
    end

    private

    def set_idea
      @idea = Idea.find(params[:id])
    end

    def filtered_collection_options
      permit_params(:for_division, :filter).merge(user: user)
    end

    def idea_params
      permit_params(:description, :end_date, :title).merge(author: current_user)
    end
  end
end
