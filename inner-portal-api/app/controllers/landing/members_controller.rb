# frozen_string_literal: true

module Landing
  class MembersController < APIController
    def index
      render json: Landing::MemberSerializer.render(Landing::Member.all)
    end
  end
end
