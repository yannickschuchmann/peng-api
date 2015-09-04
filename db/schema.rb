# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150904132606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string   "type"
    t.integer  "round_id"
    t.integer  "actor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "actions", ["actor_id"], name: "index_actions_on_actor_id", using: :btree
  add_index "actions", ["round_id"], name: "index_actions_on_round_id", using: :btree

  create_table "actors", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "duel_id"
    t.integer  "hit_points"
    t.integer  "shots"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "actors", ["duel_id"], name: "index_actors_on_duel_id", using: :btree
  add_index "actors", ["user_id"], name: "index_actors_on_user_id", using: :btree

  create_table "characters", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name_de"
  end

  create_table "duels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "bet"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "duel_id"
    t.integer  "rid"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rounds", ["duel_id"], name: "index_rounds_on_duel_id", using: :btree

  create_table "user_providers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "oauth_provider"
    t.string   "oauth_uid"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "user_providers", ["user_id"], name: "index_user_providers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "uid"
    t.string   "nick"
    t.string   "phone"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "character_id"
    t.string   "slogan"
  end

  add_index "users", ["character_id"], name: "index_users_on_character_id", using: :btree

  add_foreign_key "user_providers", "users"
end
