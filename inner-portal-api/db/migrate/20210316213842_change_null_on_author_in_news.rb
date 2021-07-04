# frozen_string_literal: true

class ChangeNullOnAuthorInNews < ActiveRecord::Migration[6.1]
  def change
    change_column_null :news, :author_id, true
  end
end
