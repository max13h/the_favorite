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

ActiveRecord::Schema[7.0].define(version: 2023_09_25_131735) do
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "competitions", force: :cascade do |t|
    t.bigint "family_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "reward"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_competitions_on_family_id"
    t.index ["user_id"], name: "index_competitions_on_user_id"
  end

  create_table "competitions_tasks", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "competition_id", null: false
    t.boolean "is_done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["competition_id"], name: "index_competitions_tasks_on_competition_id"
    t.index ["task_id"], name: "index_competitions_tasks_on_task_id"
    t.index ["user_id"], name: "index_competitions_tasks_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.date "date"
    t.bigint "user_id"
    t.bigint "kid_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "competition_id"
    t.index ["competition_id"], name: "index_events_on_competition_id"
    t.index ["kid_id"], name: "index_events_on_kid_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
  end

  create_table "kids", force: :cascade do |t|
    t.string "name"
    t.string "blood_type"
    t.string "doctor_number"
    t.bigint "family_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_kids_on_family_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "competition_id", null: false
    t.integer "score", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_scores_on_competition_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.date "deadline"
    t.boolean "is_recurent", default: false
    t.bigint "kid_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kid_id"], name: "index_tasks_on_kid_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "family_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["family_id"], name: "index_users_on_family_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "competitions", "families"
  add_foreign_key "competitions", "users"
  add_foreign_key "competitions_tasks", "competitions"
  add_foreign_key "competitions_tasks", "tasks"
  add_foreign_key "competitions_tasks", "users"
  add_foreign_key "events", "competitions"
  add_foreign_key "events", "kids"
  add_foreign_key "events", "users"
  add_foreign_key "kids", "families"
  add_foreign_key "notifications", "users"
  add_foreign_key "scores", "competitions"
  add_foreign_key "scores", "users"
  add_foreign_key "tasks", "kids"
  add_foreign_key "users", "families"
end
