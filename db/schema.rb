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

ActiveRecord::Schema[8.1].define(version: 2026_04_08_100505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "trackable_id", null: false
    t.string "trackable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable"
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "industry"
    t.string "name"
    t.text "notes"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.string "website"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.text "notes"
    t.string "phone"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contacts_on_company_id"
  end

  create_table "deals", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "contact_id"
    t.datetime "created_at", null: false
    t.string "name"
    t.text "notes"
    t.integer "position"
    t.string "stage"
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 12, scale: 2
    t.index ["company_id"], name: "index_deals_on_company_id"
    t.index ["contact_id"], name: "index_deals_on_contact_id"
  end

  add_foreign_key "contacts", "companies"
  add_foreign_key "deals", "companies"
  add_foreign_key "deals", "contacts"
end
