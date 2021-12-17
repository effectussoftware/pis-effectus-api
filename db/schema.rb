# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_13_162503) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.string "value"
    t.datetime "answered_at"
    t.bigint "question_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "communications", force: :cascade do |t|
    t.text "title"
    t.text "text"
    t.boolean "published", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "recurrent_on"
    t.boolean "dummy", default: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal "cost", precision: 9, scale: 2, default: "0.0"
    t.datetime "updated_event_at"
    t.boolean "cancelled", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description"
    t.boolean "published", default: false
    t.string "currency", default: "pesos"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.boolean "attend"
    t.boolean "confirmation", default: false
    t.datetime "changed_last_seen"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "notification_sent", default: false
    t.index ["event_id"], name: "index_invitations_on_event_id"
    t.index ["user_id", "event_id"], name: "index_invitations_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "multiple_choice_answers", force: :cascade do |t|
    t.string "value"
    t.datetime "answered_at"
    t.bigint "question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_multiple_choice_answers_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.integer "min_range"
    t.integer "max_range"
    t.string "options", default: [], array: true
    t.bigint "survey_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["survey_id"], name: "index_questions_on_survey_id"
  end

  create_table "review_action_items", force: :cascade do |t|
    t.text "description"
    t.boolean "completed"
    t.integer "reviewer_review_id"
    t.integer "user_review_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reviewer_review_id"], name: "index_review_action_items_on_reviewer_review_id"
    t.index ["user_review_id"], name: "index_review_action_items_on_user_review_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comments"
    t.string "title"
    t.bigint "reviewer_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "name"
    t.string "picture"
    t.string "email"
    t.boolean "is_admin", default: false
    t.boolean "is_active", default: true
    t.json "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "invitations", "events"
  add_foreign_key "invitations", "users"
  add_foreign_key "multiple_choice_answers", "questions"
  add_foreign_key "questions", "surveys"
  add_foreign_key "reviews", "users"
  add_foreign_key "reviews", "users", column: "reviewer_id"
end
