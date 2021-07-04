# frozen_string_literal: true

class DropPgSearchDocuments < ActiveRecord::Migration[6.1]
  def change
    drop_table :pg_search_documents do |t|
      t.text :content
      t.references :searchable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
