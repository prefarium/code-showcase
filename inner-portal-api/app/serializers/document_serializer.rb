# frozen_string_literal: true

class DocumentSerializer < BaseSerializer
  field :name
  field :link do |doc|
    doc.file.attached? ? blob_url_for(doc.file) : nil
  end
end
