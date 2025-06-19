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

ActiveRecord::Schema[7.2].define(version: 2025_05_09_024437) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.date "date_of_birth"
    t.bigint "business_id"
    t.index ["business_id"], name: "index_customers_on_business_id"
  end

  create_table "inventory_logs", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "change_quantity"
    t.datetime "date"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sales_transaction_id"
    t.index ["product_id"], name: "index_inventory_logs_on_product_id"
    t.index ["sales_transaction_id"], name: "index_inventory_logs_on_sales_transaction_id"
  end

  create_table "mpesa_transactions", force: :cascade do |t|
    t.decimal "total_amount"
    t.string "code"
    t.string "status"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions_roles", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_permissions_roles_on_permission_id"
    t.index ["role_id"], name: "index_permissions_roles_on_role_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id"
    t.index ["business_id"], name: "index_product_categories_on_business_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "quantity"
    t.decimal "buying_price"
    t.bigint "product_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id"
    t.decimal "selling_price"
    t.index ["business_id"], name: "index_products_on_business_id"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "transaction_items", force: :cascade do |t|
    t.bigint "transaction_record_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price"
    t.index ["product_id"], name: "index_transaction_items_on_product_id"
    t.index ["transaction_record_id"], name: "index_transaction_items_on_transaction_record_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "customer_id"
    t.datetime "date"
    t.decimal "total_amount"
    t.decimal "discount"
    t.string "payment_method"
    t.string "status"
    t.bigint "mpesa_transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.bigint "business_id"
    t.index ["business_id"], name: "index_transactions_on_business_id"
    t.index ["customer_id"], name: "index_transactions_on_customer_id"
    t.index ["mpesa_transaction_id"], name: "index_transactions_on_mpesa_transaction_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.decimal "revenue"
    t.string "revenue_type"
    t.string "password"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "supabase_id"
    t.bigint "business_id"
    t.index ["business_id"], name: "index_users_on_business_id"
  end

  add_foreign_key "customers", "businesses"
  add_foreign_key "inventory_logs", "products"
  add_foreign_key "inventory_logs", "transactions", column: "sales_transaction_id"
  add_foreign_key "permissions_roles", "permissions"
  add_foreign_key "permissions_roles", "roles"
  add_foreign_key "product_categories", "businesses"
  add_foreign_key "products", "businesses"
  add_foreign_key "products", "product_categories"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
  add_foreign_key "transaction_items", "products"
  add_foreign_key "transaction_items", "transactions", column: "transaction_record_id"
  add_foreign_key "transactions", "businesses"
  add_foreign_key "transactions", "customers"
  add_foreign_key "transactions", "mpesa_transactions"
  add_foreign_key "transactions", "users"
  add_foreign_key "users", "businesses"
end
