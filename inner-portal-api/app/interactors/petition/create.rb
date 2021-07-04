# frozen_string_literal: true

class Petition
  class Create
    include Interactor

    def call
      params   = context.petition_params
      petition = context.petition = Petition.new(params)

      return if petition.save

      context.fail!(error_message: error_messages_of(petition), error_status: :unprocessable_entity)
    end

    def rollback
      context.petition.reload.destroy!
    end
  end
end
