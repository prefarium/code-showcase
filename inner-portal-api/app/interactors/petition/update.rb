# frozen_string_literal: true

class Petition
  class Update
    include Interactor

    def call
      params   = context.petition_params
      petition = context.petition

      context.petition_attributes_backup = petition.attributes

      return if petition.update(params)

      context.fail!(error_message: error_messages_of(petition), error_status: :unprocessable_entity)
    end

    def rollback
      context.petition.reload.update!(context.petition_attributes_backup)
    end
  end
end
