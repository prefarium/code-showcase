# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_26_123004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "data_fingerprint"
    t.string "type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "controls", force: :cascade do |t|
    t.bigint "division_id", null: false
    t.bigint "manager_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["division_id"], name: "index_controls_on_division_id"
    t.index ["manager_id"], name: "index_controls_on_manager_id"
  end

  create_table "dashboards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "tasks", default: true, null: false
    t.boolean "events", default: true, null: false
    t.boolean "birthdays", default: true, null: false
    t.boolean "news", default: true, null: false
    t.boolean "today", default: true, null: false
    t.boolean "ideas", default: true, null: false
    t.boolean "petitions", default: true, null: false
    t.boolean "documents", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "divisions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_divisions_on_name", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_documents_on_name", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "author_id"
    t.integer "type"
    t.boolean "confirmable", null: false
    t.integer "status"
    t.string "title"
    t.text "description"
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type_in_russian"
    t.datetime "deleted_at"
    t.index ["author_id"], name: "index_events_on_author_id"
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "body", null: false
    t.integer "status", default: 1, null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_feedbacks_on_author_id"
  end

  create_table "ideas", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "division_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "status", default: 1, null: false
    t.date "end_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_ideas_on_author_id"
    t.index ["division_id"], name: "index_ideas_on_division_id"
  end

  create_table "landing_abouts", force: :cascade do |t|
    t.text "text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "landing_binds", force: :cascade do |t|
    t.bigint "landing_competence_id", null: false
    t.bigint "landing_project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["landing_competence_id"], name: "index_landing_binds_on_landing_competence_id"
    t.index ["landing_project_id"], name: "index_landing_binds_on_landing_project_id"
  end

  create_table "landing_competences", force: :cascade do |t|
    t.string "title", null: false
    t.text "text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "landing_group_binds", force: :cascade do |t|
    t.bigint "landing_competence_id", null: false
    t.bigint "landing_project_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["landing_competence_id"], name: "index_landing_group_binds_on_landing_competence_id"
    t.index ["landing_project_group_id"], name: "index_landing_group_binds_on_landing_project_group_id"
  end

  create_table "landing_header_cards", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "landing_headers", force: :cascade do |t|
    t.string "title", null: false
    t.string "text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "landing_history_marks", force: :cascade do |t|
    t.integer "year", null: false
    t.text "text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "landing_members", force: :cascade do |t|
    t.string "position", null: false
    t.text "quote", null: false
    t.text "text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
  end

  create_table "landing_project_groups", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle", null: false
    t.text "text_on_cover", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order_number"
  end

  create_table "landing_projects", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle", null: false
    t.text "text_on_cover", null: false
    t.text "text", null: false
    t.bigint "landing_project_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "show_on_root", default: false, null: false
    t.integer "order_number"
    t.index ["landing_project_group_id"], name: "index_landing_projects_on_landing_project_group_id"
  end

  create_table "landing_texts", force: :cascade do |t|
    t.integer "section_name", null: false
    t.text "text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "news", force: :cascade do |t|
    t.bigint "author_id"
    t.integer "status", default: 1, null: false
    t.string "title", null: false
    t.text "body", null: false
    t.date "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "for_landing", default: false, null: false
    t.boolean "for_portal", default: false, null: false
    t.index ["author_id"], name: "index_news_on_author_id"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "email", default: true, null: false
    t.boolean "browser", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "recipient_id", null: false
    t.string "title", null: false
    t.string "body", null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notifiable_type"
    t.bigint "notifiable_id"
    t.string "link"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "participant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_participations_on_deleted_at"
    t.index ["event_id"], name: "index_participations_on_event_id"
    t.index ["participant_id"], name: "index_participations_on_participant_id"
  end

  create_table "petitions", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "denial_reason"
    t.index ["author_id"], name: "index_petitions_on_author_id"
  end

  create_table "pins", force: :cascade do |t|
    t.bigint "pinner_id", null: false
    t.bigint "idea_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["idea_id"], name: "index_pins_on_idea_id"
    t.index ["pinner_id"], name: "index_pins_on_pinner_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_positions_on_name", unique: true
  end

  create_table "surveys", force: :cascade do |t|
    t.string "name", null: false
    t.string "link", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.date "deadline"
    t.integer "status", default: 1, null: false
    t.text "description"
    t.bigint "assignee_id", null: false
    t.bigint "author_id", null: false
    t.string "reject_reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.datetime "status_changed_at"
    t.index ["assignee_id"], name: "index_tasks_on_assignee_id"
    t.index ["author_id"], name: "index_tasks_on_author_id"
    t.index ["deleted_at"], name: "index_tasks_on_deleted_at"
  end

  create_table "telegram_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "username", null: false
    t.string "chat_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_id"], name: "index_telegram_accounts_on_chat_id", unique: true
    t.index ["user_id"], name: "index_telegram_accounts_on_user_id"
    t.index ["username"], name: "index_telegram_accounts_on_username", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "email", null: false
    t.string "phone"
    t.string "password_digest", null: false
    t.string "actual_position"
    t.string "reset_token"
    t.bigint "paper_division_id", null: false
    t.bigint "division_id", null: false
    t.bigint "position_id", null: false
    t.date "birth_date", null: false
    t.integer "role", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["division_id"], name: "index_users_on_division_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["paper_division_id"], name: "index_users_on_paper_division_id"
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["position_id"], name: "index_users_on_position_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "controls", "divisions"
  add_foreign_key "controls", "users", column: "manager_id"
  add_foreign_key "dashboards", "users"
  add_foreign_key "events", "users", column: "author_id"
  add_foreign_key "feedbacks", "users", column: "author_id"
  add_foreign_key "ideas", "divisions"
  add_foreign_key "ideas", "users", column: "author_id"
  add_foreign_key "landing_binds", "landing_competences"
  add_foreign_key "landing_binds", "landing_projects"
  add_foreign_key "landing_group_binds", "landing_competences"
  add_foreign_key "landing_group_binds", "landing_project_groups"
  add_foreign_key "landing_projects", "landing_project_groups"
  add_foreign_key "news", "users", column: "author_id"
  add_foreign_key "notification_settings", "users"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "participations", "events"
  add_foreign_key "participations", "users", column: "participant_id"
  add_foreign_key "petitions", "users", column: "author_id"
  add_foreign_key "pins", "ideas"
  add_foreign_key "pins", "users", column: "pinner_id"
  add_foreign_key "tasks", "users", column: "assignee_id"
  add_foreign_key "tasks", "users", column: "author_id"
  add_foreign_key "telegram_accounts", "users"
  add_foreign_key "users", "divisions"
  add_foreign_key "users", "divisions", column: "paper_division_id"
  add_foreign_key "users", "positions"
end
