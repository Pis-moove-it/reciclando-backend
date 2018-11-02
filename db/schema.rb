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

ActiveRecord::Schema.define(version: 2018_11_02_181633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "bales", force: :cascade do |t|
    t.float "weight"
    t.integer "material"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.bigint "user_id"
    t.index ["organization_id"], name: "index_bales_on_organization_id"
    t.index ["user_id"], name: "index_bales_on_user_id"
  end

  create_table "collection_points", force: :cascade do |t|
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "status"
    t.boolean "active"
    t.bigint "organization_id"
    t.float "kg_recycled_plastic"
    t.float "kg_recycled_glass"
    t.float "kg_trash"
    t.index ["organization_id"], name: "index_collection_points_on_organization_id"
  end

  create_table "collections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "collection_point_id"
    t.bigint "route_id"
    t.index ["collection_point_id"], name: "index_collections_on_collection_point_id"
    t.index ["route_id"], name: "index_collections_on_route_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "device_id"
    t.string "device_type"
    t.string "auth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "organization_id"
    t.index ["auth_token"], name: "index_devices_on_auth_token", unique: true
    t.index ["organization_id"], name: "index_devices_on_organization_id"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "pockets", force: :cascade do |t|
    t.string "serial_number"
    t.integer "state", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.float "weight"
    t.bigint "collection_id"
    t.datetime "check_in"
    t.index ["collection_id"], name: "index_pockets_on_collection_id"
    t.index ["organization_id"], name: "index_pockets_on_organization_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.string "option_a"
    t.string "option_b"
    t.string "option_c"
    t.string "option_d"
    t.integer "correct_option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routes", force: :cascade do |t|
    t.integer "length"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "travel_image"
    t.index ["user_id"], name: "index_routes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "ci"
    t.string "email"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "bales", "organizations"
  add_foreign_key "bales", "users"
  add_foreign_key "collection_points", "organizations"
  add_foreign_key "collections", "collection_points"
  add_foreign_key "collections", "routes"
  add_foreign_key "devices", "organizations"
  add_foreign_key "devices", "users"
  add_foreign_key "pockets", "collections"
  add_foreign_key "pockets", "organizations"
  add_foreign_key "routes", "users"
  add_foreign_key "users", "organizations"
end
