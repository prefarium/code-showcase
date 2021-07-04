# frozen_string_literal: true

class Document
  class Update
    include Interactor

    def call
      document = context.document
      params   = context.document_params
      file     = context.file

      context.document_attributes_backup = document.attributes

      unless document.update(params)
        context.fail!(error_message: error_messages_of(document), error_status: :unprocessable_entity)
      end

      document.file.attach(file) if file.present?
    end

    def rollback
      context.document.reload.update!(context.document_attributes_backup)
    end
  end
end
