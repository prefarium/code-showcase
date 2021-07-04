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

ActiveRecord::Schema.define(version: 2021_01_25_163246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "keys", force: :cascade do |t|
    t.string "token", null: false
    t.bigint "user_id", null: false
    t.bigint "provider_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "sender_name"
    t.index ["provider_id"], name: "index_keys_on_provider_id"
    t.index ["token"], name: "index_keys_on_token"
    t.index ["user_id"], name: "index_keys_on_user_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "target", null: false
    t.string "content", null: false
    t.float "cost"
    t.integer "status", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "provider_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ext_id"
    t.integer "operator"
    t.index ["provider_id"], name: "index_messages_on_provider_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "login", null: false
    t.string "password", null: false
    t.string "name", null: false
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "default_sender_name", null: false
    t.index ["name"], name: "index_providers_on_name", unique: true
  end

  create_table "sender_name_requests", force: :cascade do |t|
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "provider_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_id"], name: "index_sender_name_requests_on_provider_id"
    t.index ["user_id"], name: "index_sender_name_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "keys", "providers"
  add_foreign_key "keys", "users"
  add_foreign_key "messages", "providers"
  add_foreign_key "messages", "users"
  add_foreign_key "sender_name_requests", "providers"
  add_foreign_key "sender_name_requests", "users"
end
