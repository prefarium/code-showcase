# frozen_string_literal: true

module V1
  class PetitionsController < APIController
    def create
      context = Petition::New.call(petition_params: petition_params)

      render_error_from_context(context) if context.failure?
    end

    private

    def petition_params
      permit_params(:title, :body).merge(author: current_user)
    end
  end
end
