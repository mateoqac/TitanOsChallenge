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

ActiveRecord::Schema[8.0].define(version: 2025_07_27_181538) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.bigint "streaming_app_id", null: false
    t.bigint "country_id", null: false
    t.jsonb "stream_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_availabilities_on_content_id"
    t.index ["country_id"], name: "index_availabilities_on_country_id"
    t.index ["streaming_app_id"], name: "index_availabilities_on_streaming_app_id"
  end

  create_table "contents", force: :cascade do |t|
    t.string "title"
    t.integer "year"
    t.integer "duration_in_seconds"
    t.string "type"
    t.integer "number"
    t.integer "season_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tv_show_id"
    t.bigint "season_id"
    t.bigint "channel_id"
    t.index ["channel_id"], name: "index_contents_on_channel_id"
    t.index ["season_id"], name: "index_contents_on_season_id"
    t.index ["tv_show_id"], name: "index_contents_on_tv_show_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_schedules_on_content_id"
  end

  create_table "streaming_apps", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_favorites", force: :cascade do |t|
    t.integer "user_id"
    t.string "favoritable_type", null: false
    t.bigint "favoritable_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favoritable_type", "favoritable_id"], name: "index_user_favorites_on_favoritable"
  end

  create_table "viewing_times", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.integer "user_id"
    t.integer "time_watched"
    t.datetime "viewed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_viewing_times_on_content_id"
  end

  add_foreign_key "availabilities", "contents"
  add_foreign_key "availabilities", "countries"
  add_foreign_key "availabilities", "streaming_apps"
  add_foreign_key "contents", "contents", column: "channel_id"
  add_foreign_key "contents", "contents", column: "season_id"
  add_foreign_key "contents", "contents", column: "tv_show_id"
  add_foreign_key "schedules", "contents"
  add_foreign_key "viewing_times", "contents"
end
