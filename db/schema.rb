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

ActiveRecord::Schema.define(version: 20130711092737) do

  create_table "companies", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "zip_code"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.text     "billing_address"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sent_to_collector"
    t.boolean  "active"
    t.integer  "user_id"
    t.string   "account"
  end

  add_index "customers", ["company_id"], name: "index_customers_on_company_id"
  add_index "customers", ["user_id"], name: "index_customers_on_user_id"

  create_table "email_actions", force: true do |t|
    t.datetime "sent_at"
    t.datetime "viewed_at"
    t.integer  "customer_id"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mandrill_id"
    t.integer  "user_id"
    t.integer  "company_id"
  end

  add_index "email_actions", ["company_id"], name: "index_email_actions_on_company_id"
  add_index "email_actions", ["customer_id"], name: "index_email_actions_on_customer_id"
  add_index "email_actions", ["invoice_id"], name: "index_email_actions_on_invoice_id"
  add_index "email_actions", ["user_id"], name: "index_email_actions_on_user_id"

  create_table "invoice_has_services", force: true do |t|
    t.integer  "invoice_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "qty"
  end

  add_index "invoice_has_services", ["invoice_id"], name: "index_invoice_has_services_on_invoice_id"
  add_index "invoice_has_services", ["service_id"], name: "index_invoice_has_services_on_service_id"

  create_table "invoices", force: true do |t|
    t.date     "date"
    t.integer  "number"
    t.date     "due_date"
    t.float    "amount"
    t.integer  "company_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "invoices", ["company_id"], name: "index_invoices_on_company_id"
  add_index "invoices", ["customer_id"], name: "index_invoices_on_customer_id"
  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id"

  create_table "services", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
  end

  add_index "services", ["company_id"], name: "index_services_on_company_id"

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

  add_index "transactions", ["company_id"], name: "index_transactions_on_company_id"
  add_index "transactions", ["customer_id"], name: "index_transactions_on_customer_id"
  add_index "transactions", ["invoice_id"], name: "index_transactions_on_invoice_id"

  create_table "user_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_salt"
    t.string   "password_hash"
    t.integer  "company_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "job"
  end

  create_table "worksons", force: true do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
