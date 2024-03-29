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

ActiveRecord::Schema[7.0].define(version: 2024_02_18_003416) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.integer "account_type", default: 0, null: false
    t.bigint "institution_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.text "headers", default: [], array: true
    t.boolean "headers_in_file", default: true
    t.string "date_format", default: "%m/%d/%Y"
    t.boolean "expenses_negative", default: true
    t.index ["institution_id"], name: "index_accounts_on_institution_id"
  end

  create_table "balance_entries", force: :cascade do |t|
    t.date "posted_on"
    t.integer "value_cents", default: 0, null: false
    t.string "value_currency", default: "CAD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_balance_entries_on_account_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "keywords", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transaction_type", default: 0
  end

  create_table "institutions", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency"
    t.index ["slug"], name: "index_institutions_on_slug", unique: true
  end

  create_table "transaction_batches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file"
    t.date "period_start"
    t.date "period_end"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_transaction_batches_on_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.date "posted_on", null: false
    t.integer "value_cents", default: 0, null: false
    t.string "value_currency", default: "CAD", null: false
    t.text "description"
    t.integer "status", default: 0, null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "transaction_batch_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["transaction_batch_id"], name: "index_transactions_on_transaction_batch_id"
  end

  add_foreign_key "accounts", "institutions"
  add_foreign_key "balance_entries", "accounts"
  add_foreign_key "transaction_batches", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "transaction_batches"
end
