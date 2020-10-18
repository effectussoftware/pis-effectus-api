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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2020_10_17_163958) do
=======
ActiveRecord::Schema.define(version: 2020_10_15_220149) do
>>>>>>> b6dabdecd85c1a47fe98ae84c18cc68c612c36df

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "review_action_items", force: :cascade do |t|
    t.text "description"
    t.integer "type"
    t.bigint "user_id", null: false
    t.bigint "review_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "completed"
    t.index ["review_id"], name: "index_review_action_items_on_review_id"
    t.index ["user_id"], name: "index_review_action_items_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "reviewer_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
    
  create_table "communications", force: :cascade do |t|
    t.text "title"
    t.text "text"
    t.boolean "published", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "recurrent_on"
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

  add_foreign_key "review_action_items", "reviews"
  add_foreign_key "review_action_items", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "reviews", "users", column: "reviewer_id"
end
