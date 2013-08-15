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

ActiveRecord::Schema.define(version: 20130811144810) do

  create_table "actions", force: true do |t|
    t.datetime "sent_at"
    t.datetime "viewed_at"
    t.integer  "customer_id"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "action_type"
    t.text     "text_note"
  end

  add_index "actions", ["company_id"], name: "index_actions_on_company_id", using: :btree
  add_index "actions", ["customer_id"], name: "index_actions_on_customer_id", using: :btree
  add_index "actions", ["invoice_id"], name: "index_actions_on_invoice_id", using: :btree
  add_index "actions", ["user_id"], name: "index_actions_on_user_id", using: :btree

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "zip_code"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sent_to_collector"
    t.boolean  "active"
    t.integer  "user_id"
    t.string   "account"
    t.string   "organization_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "state"
    t.string   "city"
    t.string   "zip_code"
    t.string   "industry"
    t.string   "company_size"
  end

  add_index "customers", ["company_id"], name: "index_customers_on_company_id", using: :btree
  add_index "customers", ["user_id"], name: "index_customers_on_user_id", using: :btree

  create_table "future_actions", force: true do |t|
    t.integer  "invoice_id"
    t.boolean  "sms_notification"
    t.boolean  "email_notification"
    t.integer  "duration_type"
    t.integer  "starting_day"
    t.integer  "starting_week_day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "invoice_creation"
  end

  create_table "invoice_has_services", force: true do |t|
    t.integer  "invoice_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "qty"
  end

  add_index "invoice_has_services", ["invoice_id"], name: "index_invoice_has_services_on_invoice_id", using: :btree
  add_index "invoice_has_services", ["service_id"], name: "index_invoice_has_services_on_service_id", using: :btree

  create_table "invoices", force: true do |t|
    t.date     "date"
    t.string   "number"
    t.date     "due_date"
    t.float    "amount"
    t.integer  "company_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "status"
    t.string   "state"
    t.integer  "future_action_id"
  end

  add_index "invoices", ["company_id"], name: "index_invoices_on_company_id", using: :btree
  add_index "invoices", ["customer_id"], name: "index_invoices_on_customer_id", using: :btree
  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "recurring_contact_data", force: true do |t|
    t.string   "sms_number"
    t.string   "sms_body"
    t.string   "email_to"
    t.string   "email_from"
    t.text     "email_body"
    t.text     "email_cc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recurring_invoice_id"
  end

  create_table "recurring_invoices", force: true do |t|
    t.boolean  "sms_notification"
    t.boolean  "email_notification"
    t.boolean  "daily"
    t.boolean  "weekly"
    t.boolean  "monthly"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
  end

  add_index "services", ["company_id"], name: "index_services_on_company_id", using: :btree

  create_table "transactions", force: true do |t|
    t.date     "date"
    t.string   "type"
    t.integer  "number"
    t.float    "amount"
    t.integer  "invoice_id"
    t.integer  "company_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["company_id"], name: "index_transactions_on_company_id", using: :btree
  add_index "transactions", ["customer_id"], name: "index_transactions_on_customer_id", using: :btree
  add_index "transactions", ["invoice_id"], name: "index_transactions_on_invoice_id", using: :btree

  create_table "user_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_salt"
    t.string   "password_hash"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job"
    t.boolean  "salesman"
    t.boolean  "accountant"
    t.boolean  "collector"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "worksons", force: true do |t|
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "worksons", ["user_id"], name: "index_worksons_on_user_id", using: :btree

end
