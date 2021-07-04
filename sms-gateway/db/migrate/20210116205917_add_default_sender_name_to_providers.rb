# frozen_string_literal: true

# noinspection RubyClassModuleNamingConvention
class AddDefaultSenderNameToProviders < ActiveRecord::Migration[6.1]
  def change
    # rubocop:disable Rails/NotNullColumn
    # There is production DB so the migration is sage
    add_column :providers, :default_sender_name, :string, null: false
    # rubocop:enable Rails/NotNullColumn
  end
end
