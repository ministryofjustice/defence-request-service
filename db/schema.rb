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

ActiveRecord::Schema.define(version: 20150421123400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "btree_gist"
  enable_extension "pg_trgm"

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "defence_requests", force: :cascade do |t|
    t.string   "solicitor_type",                                        null: false
    t.string   "solicitor_name"
    t.string   "solicitor_firm"
    t.string   "scheme"
    t.string   "phone_number"
    t.string   "detainee_name"
    t.string   "gender"
    t.datetime "date_of_birth"
    t.string   "custody_number"
    t.string   "offences"
    t.datetime "time_of_arrival"
    t.text     "comments"
    t.boolean  "adult"
    t.boolean  "appropriate_adult",                     default: false, null: false
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "dscc_number"
    t.datetime "interview_start_time"
    t.integer  "solicitor_id"
    t.integer  "detainee_age"
    t.integer  "cco_id"
    t.datetime "solicitor_time_of_arrival"
    t.text     "reason_aborted"
    t.text     "appropriate_adult_reason"
    t.string   "house_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.string   "custody_address"
    t.string   "investigating_officer_name"
    t.string   "investigating_officer_shoulder_number"
    t.string   "investigating_officer_contact_number"
    t.text     "circumstances_of_arrest"
    t.datetime "time_of_arrest"
    t.datetime "time_of_detention_authorised"
    t.boolean  "fit_for_interview",                     default: true,  null: false
    t.text     "unfit_for_interview_reason"
    t.boolean  "interpreter_required",                  default: false, null: false
    t.text     "interpreter_type"
  end

  add_index "defence_requests", ["dscc_number"], name: "dscc_number_index", using: :gist
  add_index "defence_requests", ["solicitor_id"], name: "index_defence_requests_on_solicitor_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
