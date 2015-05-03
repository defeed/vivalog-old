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

ActiveRecord::Schema.define(version: 20150503100918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: :cascade do |t|
    t.integer  "project_id",  null: false
    t.integer  "user_id",     null: false
    t.date     "worked_on",   null: false
    t.decimal  "coefficient"
    t.integer  "workers"
    t.string   "work_type",   null: false
    t.decimal  "hours"
    t.decimal  "hourly_rate"
    t.text     "comment"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "payouts", force: :cascade do |t|
    t.integer  "entry_id",    null: false
    t.integer  "user_id",     null: false
    t.integer  "project_id",  null: false
    t.decimal  "base_amount"
    t.decimal  "amount",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "payouts", ["project_id"], name: "index_payouts_on_project_id", using: :btree
  add_index "payouts", ["user_id"], name: "index_payouts_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.float    "volume"
    t.decimal  "price_receive"
    t.decimal  "price_polish"
    t.decimal  "hourly_rate"
    t.date     "start_on"
    t.date     "end_on"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "finalized_at"
    t.integer  "finalized_by"
    t.string   "code"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "name",                   default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",              default: false, null: false
    t.string   "role"
    t.decimal  "hourly_rate"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
