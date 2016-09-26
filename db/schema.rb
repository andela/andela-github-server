# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160926052120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint   "gh_event_id"
    t.string   "event_type"
    t.datetime "event_created_at"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "repo_url"
    t.string   "event_url"
    t.string   "merged"
    t.bigint   "repo_stars"
    t.integer  "comments"
    t.integer  "review_comments"
    t.integer  "commits_count"
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.bigint   "loc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stats", force: :cascade do |t|
    t.string   "event_type"
    t.integer  "commits_count"
    t.bigint   "additions_count"
    t.bigint   "deletions_count"
    t.string   "repo_name"
    t.string   "html_url"
    t.string   "language"
    t.datetime "event_created_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.bigint   "gh_event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "events", "users"
end
