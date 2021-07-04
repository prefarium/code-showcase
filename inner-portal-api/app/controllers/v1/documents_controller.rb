# frozen_string_literal: true

module V1
  class DocumentsController < APIController
    include Pagination

    def index
      render json: collection_for_rendering(Document.all.with_attached_file)
    end
  end
end
