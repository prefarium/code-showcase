# frozen_string_literal: true

class SetupEverything < ActiveRecord::Migration[6.1]
  def change
    # ----- Active Storage

    create_table :active_storage_blobs do |t|
      t.string :key, null: false
      t.string :filename, null: false
      t.string :content_type
      t.text :metadata
      t.string :service_name, null: false
      t.bigint :byte_size, null: false
      t.string :checksum, null: false
      t.datetime :created_at, null: false

      t.index [:key], unique: true
    end

    create_table :active_storage_attachments do |t|
      t.string :name, null: false
      t.references :record, null: false, polymorphic: true, index: false
      t.references :blob, null: false

      t.datetime :created_at, null: false

      t.index %i[record_type record_id name blob_id],
              name:   'index_active_storage_attachments_uniqueness',
              unique: true
      t.foreign_key :active_storage_blobs, column: :blob_id
    end

    # rubocop:disable Rails/CreateTableWithTimestamps
    create_table :active_storage_variant_records do |t|
      t.belongs_to :blob, null: false, index: false
      t.string :variation_digest, null: false

      t.index %i[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
      t.foreign_key :active_storage_blobs, column: :blob_id
    end
    # rubocop:enable Rails/CreateTableWithTimestamps

    # -----

    create_table :divisions do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :documents do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :positions do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name
      t.string :email, null: false, index: { unique: true }
      t.string :phone, index: { unique: true }
      t.string :password_digest, null: false
      t.string :actual_position
      t.string :reset_token
      t.references :division, null: false, foreign_key: true
      t.references :actual_division, null: false, foreign_key: { to_table: :divisions }
      t.references :position, null: false, foreign_key: true
      t.date :birth_date, null: false
      t.integer :role, null: false, default: 1
      t.boolean :admin, null: false, default: false

      t.timestamps
    end

    create_table :controls do |t|
      t.references :division, null: false, foreign_key: true
      t.references :manager, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    create_table :dashboards do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :tasks, null: false, default: true
      t.boolean :events, null: false, default: true
      t.boolean :birthdays, null: false, default: true
      t.boolean :news, null: false, default: true
      t.boolean :today, null: false, default: true
      t.boolean :ideas, null: false, default: true
      t.boolean :petitions, null: false, default: true
      t.boolean :documents, null: false, default: true

      t.timestamps
    end

    create_table :events do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.integer :type
      t.boolean :confirmable, null: false
      t.integer :status
      t.string :title
      t.text :description
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end

    create_table :ideas do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :division, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :status, null: false, default: 1
      t.date :end_date, null: false

      t.timestamps
    end

    create_table :news do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 1
      t.string :title, null: false
      t.text :body, null: false
      t.date :date, null: false

      t.timestamps
    end

    create_table :participations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    create_table :petitions do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :body, null: false
      t.integer :status, null: false, default: 1

      t.timestamps
    end

    create_table :pg_search_documents do |t|
      t.text :content
      t.references :searchable, polymorphic: true, index: true

      t.timestamps
    end

    create_table :pins do |t|
      t.references :pinner, null: false, foreign_key: { to_table: :users }
      t.references :idea, null: false, foreign_key: true

      t.timestamps
    end

    create_table :surveys do |t|
      t.string :name, null: false
      t.string :link, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.integer :status, null: false, default: 1

      t.timestamps
    end

    create_table :tasks do |t|
      t.string :title, null: false
      t.date :deadline
      t.integer :status, null: false, default: 1
      t.text :description
      t.references :assignee, null: false, foreign_key: { to_table: :users }
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :reject_reason

      t.timestamps
    end

    create_table :votes do |t|
      t.references :votable, polymorphic: true
      t.references :voter, polymorphic: true

      t.boolean :vote_flag
      t.string :vote_scope
      t.integer :vote_weight

      t.timestamps
    end

    add_index :votes, %i[voter_id voter_type vote_scope]
    add_index :votes, %i[votable_id votable_type vote_scope]
  end
end
