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

ActiveRecord::Schema.define(version: 20140225014721) do

  create_table "users", force: true do |t|
    t.string   "name",                     limit: 24
    t.string   "email",                    limit: 50
    t.string   "username",                 limit: 24
    t.string   "gender",                   limit: 20
    t.date     "birthdate"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "auth_token"
    t.string   "validation_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "ip_address_created"
    t.string   "ip_address_last_modified"
    t.string   "ip_address_last_login"
    t.boolean  "admin",                               default: false
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
