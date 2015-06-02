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

ActiveRecord::Schema.define(version: 20150529154920) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

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
    t.string   "detainee_name"
    t.string   "gender"
    t.datetime "date_of_birth"
    t.string   "offences"
    t.datetime "time_of_arrival"
    t.text     "comments"
    t.boolean  "adult"
    t.boolean  "appropriate_adult",                    default: false, null: false
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dscc_number"
    t.datetime "interview_start_time"
    t.datetime "solicitor_time_of_arrival"
    t.text     "reason_aborted"
    t.text     "appropriate_adult_reason"
    t.string   "investigating_officer_name"
    t.string   "investigating_officer_contact_number"
    t.text     "circumstances_of_arrest"
    t.uuid     "solicitor_uid"
    t.uuid     "cco_uid"
    t.datetime "time_of_arrest"
    t.datetime "time_of_detention_authorised"
    t.boolean  "fit_for_interview",                    default: true,  null: false
    t.text     "unfit_for_interview_reason"
    t.boolean  "interpreter_required",                 default: false, null: false
    t.text     "interpreter_type"
    t.uuid     "organisation_uid"
    t.string   "detainee_address"
    t.boolean  "detainee_name_not_given",              default: false
    t.boolean  "detainee_address_not_given",           default: false
    t.boolean  "date_of_birth_not_given",              default: false
    t.string   "custody_number"
  end

  add_index "defence_requests", ["cco_uid"], name: "index_defence_requests_on_cco_uid", using: :btree
  add_index "defence_requests", ["custody_number"], name: "index_defence_requests_on_custody_number", using: :btree
  add_index "defence_requests", ["dscc_number"], name: "index_defence_requests_on_dscc_number", unique: true, using: :btree
  add_index "defence_requests", ["organisation_uid"], name: "index_defence_requests_on_organisation_uid", using: :btree
  add_index "defence_requests", ["solicitor_uid"], name: "index_defence_requests_on_solicitor_uid", using: :btree

end
