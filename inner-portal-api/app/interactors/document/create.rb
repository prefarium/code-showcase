# frozen_string_literal: true

class Document
  class Create
    include Interactor

    def call
      params = context.document_params
      file   = context.file

      document = context.document = Document.new(params)

      if file.blank?
        context.fail!(error_message: I18n.t('errors.documents.file_not_attached'), error_status: :unprocessable_entity)
      end

      if document.save
        document.file.attach(file)
      else
        context.fail!(error_message: error_messages_of(document), error_status: :unprocessable_entity)
      end
    end

    def rollback
      context.document.reload.destroy!
    end
  end
end
