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

ActiveRecord::Schema[8.1].define(version: 2026_02_27_000002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "addon_groups", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.text "description"
    t.boolean "is_active", default: true, null: false
    t.boolean "is_required", default: false, null: false
    t.integer "max_selection"
    t.integer "min_selection", default: 0, null: false
    t.string "name", limit: 255, null: false
    t.integer "order", default: 0, null: false
    t.bigint "tenant_id", null: false
    t.datetime "updated_at", precision: 0
    t.index ["is_active"], name: "addon_groups_is_active_index"
    t.index ["order"], name: "addon_groups_order_index"
    t.index ["tenant_id"], name: "addon_groups_tenant_id_index"
  end

  create_table "addon_items", force: :cascade do |t|
    t.bigint "addon_group_id", null: false
    t.datetime "created_at", precision: 0
    t.boolean "is_available", default: true, null: false
    t.integer "max_quantity", default: 1, null: false
    t.string "name", limit: 255, null: false
    t.integer "order", default: 0, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", precision: 0
    t.index ["addon_group_id"], name: "addon_items_addon_group_id_index"
    t.index ["is_available"], name: "addon_items_is_available_index"
    t.index ["order"], name: "addon_items_order_index"
  end

  create_table "addon_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "additional_data"
    t.datetime "created_at", precision: nil
    t.integer "is_active", limit: 2, default: 1, null: false
    t.string "key_name", limit: 191
    t.text "live_values"
    t.string "mode", limit: 20, default: "live", null: false
    t.string "settings_type", limit: 255
    t.text "test_values"
    t.datetime "updated_at", precision: nil
  end

  create_table "admin_mfa_verifications", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.string "code", limit: 255, null: false
    t.datetime "created_at", precision: 0
    t.datetime "expires_at", precision: 0, null: false
    t.string "method", limit: 255, default: "whatsapp", null: false
    t.datetime "updated_at", precision: 0
    t.index ["admin_id", "code"], name: "admin_mfa_verifications_admin_id_code_index"
    t.index ["expires_at"], name: "admin_mfa_verifications_expires_at_index"
    t.check_constraint "method::text = ANY (ARRAY['email'::character varying::text, 'sms'::character varying::text, 'whatsapp'::character varying::text, 'app'::character varying::text])", name: "admin_mfa_verifications_method_check"
  end

  create_table "admin_password_history", force: :cascade do |t|
    t.bigint "adminable_id", null: false
    t.string "adminable_type", limit: 255, null: false
    t.datetime "created_at", precision: 0
    t.string "password_hash", limit: 255, null: false
    t.datetime "updated_at", precision: 0
    t.index ["adminable_type", "adminable_id", "created_at"], name: "admin_pass_hist_poly_idx"
  end

  create_table "admin_roles", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "module_access", limit: 255
    t.string "name", limit: 255
    t.boolean "status", default: true, null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "admin_sessions", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["admin_id"], name: "index_admin_sessions_on_admin_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "address", limit: 255
    t.bigint "admin_role_id", default: 2, null: false
    t.text "business_description"
    t.string "business_name", limit: 255
    t.string "business_type", limit: 255
    t.string "city", limit: 255
    t.decimal "commission_rate", precision: 5, scale: 2
    t.string "country", limit: 2, default: "BR", null: false
    t.datetime "created_at", precision: nil
    t.string "created_by", limit: 255
    t.string "document_number", limit: 255
    t.string "document_type", limit: 255
    t.string "email", limit: 100, null: false
    t.uuid "external_id", null: false
    t.string "f_name", limit: 100
    t.string "fcm_token", limit: 255
    t.string "identity_image", limit: 255
    t.string "identity_number", limit: 255
    t.string "identity_type", limit: 255
    t.string "image", limit: 100
    t.boolean "is_temporary_password", default: false, null: false
    t.string "l_name", limit: 100
    t.string "language", limit: 5, default: "pt_BR", null: false
    t.datetime "last_login_at", precision: 0
    t.string "mfa_secret", limit: 255
    t.boolean "notifications_enabled", default: true, null: false
    t.string "password", limit: 100, null: false
    t.string "phone", limit: 20
    t.string "postal_code", limit: 10
    t.datetime "privacy_policy_accepted_at", precision: 0
    t.boolean "profile_completed", default: false, null: false
    t.string "remember_token", limit: 100
    t.json "social_media"
    t.string "state", limit: 2
    t.integer "status", limit: 2, default: 1, null: false
    t.string "store_banner", limit: 255
    t.bigint "store_id"
    t.string "store_logo", limit: 255
    t.json "store_settings"
    t.string "store_slug", limit: 255
    t.json "store_theme"
    t.datetime "subscribed_at", precision: 0
    t.datetime "subscription_ends_at", precision: 0
    t.bigint "subscription_plan_id"
    t.string "subscription_status", limit: 255, default: "trial", null: false
    t.string "temporary_password", limit: 255
    t.datetime "temporary_password_expires_at", precision: 0
    t.bigint "tenant_id"
    t.string "timezone", limit: 255, default: "America/Sao_Paulo", null: false
    t.decimal "total_commission_earned", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "total_commission_paid", precision: 12, scale: 2, default: "0.0", null: false
    t.integer "total_orders", default: 0, null: false
    t.integer "total_products", default: 0, null: false
    t.decimal "total_sales", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "trial_ends_at", precision: 0
    t.datetime "updated_at", precision: nil
    t.string "website", limit: 255
    t.string "whatsapp", limit: 255
    t.index ["external_id"], name: "admins_external_id_index"
    t.index ["store_id"], name: "admins_store_id_index"
    t.index ["tenant_id"], name: "admins_tenant_id_index"
    t.check_constraint "business_type::text = ANY (ARRAY['restaurant'::character varying::text, 'grocery'::character varying::text, 'pharmacy'::character varying::text, 'fashion'::character varying::text, 'electronics'::character varying::text, 'services'::character varying::text, 'other'::character varying::text])", name: "admins_business_type_check"
    t.check_constraint "document_type::text = ANY (ARRAY['cpf'::character varying::text, 'cnpj'::character varying::text])", name: "admins_document_type_check"
    t.check_constraint "subscription_status::text = ANY (ARRAY['trial'::character varying::text, 'active'::character varying::text, 'suspended'::character varying::text, 'cancelled'::character varying::text, 'expired'::character varying::text])", name: "admins_subscription_status_check"
    t.unique_constraint ["email"], name: "admins_email_unique"
    t.unique_constraint ["external_id"], name: "admins_external_id_unique"
    t.unique_constraint ["store_slug"], name: "admins_store_slug_unique"
  end

  create_table "attribute_fields", force: :cascade do |t|
    t.bigint "attribute_id", null: false
    t.datetime "created_at", precision: 0
    t.string "field_label", limit: 255, null: false
    t.string "field_name", limit: 255, null: false
    t.json "field_options"
    t.string "field_type", limit: 255, default: "text", null: false
    t.integer "order", default: 0, null: false
    t.boolean "required", default: false, null: false
    t.datetime "updated_at", precision: 0
    t.index ["attribute_id", "order"], name: "attribute_fields_attribute_id_order_index"
    t.check_constraint "field_type::text = ANY (ARRAY['text'::character varying::text, 'number'::character varying::text, 'array'::character varying::text, 'boolean'::character varying::text, 'textarea'::character varying::text, 'image'::character varying::text])", name: "attribute_fields_field_type_check"
  end

  create_table "attributes", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name", limit: 255
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: nil
    t.index ["tenant_id"], name: "attributes_tenant_id_index"
  end

  create_table "banners", force: :cascade do |t|
    t.bigint "category_id"
    t.datetime "created_at", precision: nil
    t.uuid "external_id", null: false
    t.string "image", limit: 100
    t.bigint "product_id"
    t.integer "status", limit: 2, default: 1, null: false
    t.bigint "tenant_id"
    t.string "title", limit: 255
    t.datetime "updated_at", precision: nil
    t.index ["external_id"], name: "banners_external_id_index"
    t.index ["tenant_id"], name: "banners_tenant_id_index"
    t.unique_constraint ["external_id"], name: "banners_external_id_unique"
  end

  create_table "branch_business_hours", force: :cascade do |t|
    t.bigint "branch_id", null: false
    t.time "closing_time", precision: 0
    t.datetime "created_at", precision: 0
    t.integer "day", limit: 2, null: false, comment: "0=Sunday, 6=Saturday"
    t.boolean "is_closed", default: true, null: false
    t.time "opening_time", precision: 0
    t.datetime "updated_at", precision: 0
    t.index ["branch_id"], name: "branch_business_hours_branch_id_index"
    t.index ["day"], name: "branch_business_hours_day_index"
    t.unique_constraint ["branch_id", "day"], name: "branch_business_hours_branch_id_day_unique"
  end

  create_table "branches", force: :cascade do |t|
    t.text "address"
    t.integer "coverage", default: 1, null: false
    t.datetime "created_at", precision: nil
    t.string "email", limit: 255
    t.uuid "external_id", null: false
    t.string "image", limit: 255
    t.boolean "is_always_open", default: false, null: false, comment: "If true, bypasses business hours validation"
    t.boolean "is_temporarily_closed", default: false, null: false, comment: "If true, branch is closed regardless of schedule"
    t.string "latitude", limit: 255
    t.string "longitude", limit: 255
    t.string "name", limit: 255
    t.string "password", limit: 255
    t.string "phone", limit: 255
    t.string "remember_token", limit: 255
    t.bigint "restaurant_id"
    t.integer "status", limit: 2, default: 1, null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: nil
    t.index ["external_id"], name: "branches_external_id_index"
    t.index ["tenant_id"], name: "branches_tenant_id_index"
    t.unique_constraint ["external_id"], name: "branches_external_id_unique"
  end

  create_table "business_settings", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "key", limit: 255
    t.datetime "updated_at", precision: nil
    t.text "value"
  end

  create_table "cadatech_admins", force: :cascade do |t|
    t.string "avatar", limit: 255
    t.datetime "created_at", precision: 0
    t.bigint "created_by"
    t.string "email", limit: 255, null: false
    t.datetime "email_verified_at", precision: 0
    t.string "language", limit: 5, default: "pt", null: false
    t.datetime "last_activity_at", precision: 0
    t.datetime "last_login_at", precision: 0
    t.datetime "locked_until", precision: 0
    t.integer "login_attempts", default: 0, null: false
    t.json "mfa_backup_codes"
    t.boolean "mfa_enabled", default: false, null: false
    t.string "mfa_secret", limit: 255
    t.datetime "mfa_verified_at", precision: 0
    t.string "name", limit: 255, null: false
    t.boolean "notifications_enabled", default: true, null: false
    t.string "password", limit: 255, null: false
    t.string "password_digest"
    t.json "permissions", comment: "Permissões específicas"
    t.string "remember_token", limit: 255
    t.string "role", limit: 255, default: "admin", null: false
    t.string "status", limit: 255, default: "active", null: false
    t.string "timezone", limit: 50, default: "America/Sao_Paulo", null: false
    t.datetime "updated_at", precision: 0
    t.index ["email"], name: "cadatech_admins_email_index"
    t.index ["role"], name: "cadatech_admins_role_index"
    t.index ["status"], name: "cadatech_admins_status_index"
    t.check_constraint "role::text = ANY (ARRAY['super_admin'::character varying::text, 'admin'::character varying::text, 'moderator'::character varying::text, 'support'::character varying::text])", name: "cadatech_admins_role_check"
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying::text, 'inactive'::character varying::text, 'suspended'::character varying::text])", name: "cadatech_admins_status_check"
    t.unique_constraint ["email"], name: "cadatech_admins_email_unique"
  end

  create_table "cadatech_password_reset_tokens", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "email", limit: 255, null: false
    t.datetime "expires_at", precision: 0, null: false
    t.string "token", limit: 255, null: false
    t.datetime "updated_at", precision: 0
    t.index ["email", "token"], name: "cadatech_password_reset_tokens_email_token_index"
    t.index ["expires_at"], name: "cadatech_password_reset_tokens_expires_at_index"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "image", limit: 255, default: "def.png", null: false
    t.string "name", limit: 255
    t.bigint "parent_id", null: false
    t.integer "position", null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.integer "status", limit: 2, default: 1, null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: nil
    t.index ["tenant_id"], name: "categories_tenant_id_index"
  end

  create_table "category_discounts", force: :cascade do |t|
    t.integer "category_id", null: false
    t.datetime "created_at", precision: 0
    t.float "discount_amount", default: 0.0, null: false
    t.string "discount_type", limit: 255
    t.date "expire_date"
    t.float "maximum_amount", default: 0.0, null: false
    t.string "name", limit: 255
    t.date "start_date"
    t.integer "status", limit: 2, default: 0, null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: 0
    t.index ["tenant_id"], name: "category_discounts_tenant_id_index"
    t.unique_constraint ["category_id"], name: "category_discounts_category_id_unique"
  end

  create_table "category_searched_by_user", force: :cascade do |t|
    t.bigint "category_id"
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
  end

  create_table "chart_of_accounts", force: :cascade do |t|
    t.string "account_code", limit: 20, null: false
    t.string "account_name", limit: 100, null: false
    t.string "account_type", limit: 255, null: false
    t.datetime "created_at", precision: 0
    t.text "description"
    t.boolean "is_active", default: true, null: false
    t.boolean "is_system_account", default: false, null: false
    t.string "normal_balance", limit: 255, null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: 0
    t.index ["account_code"], name: "chart_of_accounts_account_code_index"
    t.index ["tenant_id", "account_type"], name: "chart_of_accounts_tenant_id_account_type_index"
    t.check_constraint "account_type::text = ANY (ARRAY['asset'::character varying::text, 'liability'::character varying::text, 'equity'::character varying::text, 'revenue'::character varying::text, 'expense'::character varying::text])", name: "chart_of_accounts_account_type_check"
    t.check_constraint "normal_balance::text = ANY (ARRAY['debit'::character varying::text, 'credit'::character varying::text])", name: "chart_of_accounts_normal_balance_check"
    t.unique_constraint ["account_code"], name: "chart_of_accounts_account_code_unique"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "checked", limit: 2, default: 0, null: false
    t.datetime "created_at", precision: nil
    t.text "image"
    t.integer "is_reply", limit: 2, default: 0, null: false
    t.text "message"
    t.text "reply"
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: nil
    t.string "user_id", limit: 255
    t.index ["tenant_id"], name: "conversations_tenant_id_index"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "code", limit: 15
    t.string "coupon_type", limit: 255, default: "default", null: false
    t.datetime "created_at", precision: nil
    t.integer "customer_id"
    t.decimal "discount", precision: 8, scale: 2, default: "0.0", null: false
    t.string "discount_type", limit: 15, default: "percentage", null: false
    t.date "expire_date"
    t.integer "limit"
    t.decimal "max_discount", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "min_purchase", precision: 8, scale: 2, default: "0.0", null: false
    t.date "start_date"
    t.integer "status", limit: 2, default: 1, null: false
    t.bigint "tenant_id"
    t.string "title", limit: 100
    t.datetime "updated_at", precision: nil
    t.index ["tenant_id"], name: "coupons_tenant_id_index"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "country", limit: 255
    t.datetime "created_at", precision: nil
    t.string "currency_code", limit: 255
    t.string "currency_symbol", limit: 255
    t.decimal "exchange_rate", precision: 8, scale: 2
    t.datetime "updated_at", precision: nil
  end

  create_table "customer_addresses", force: :cascade do |t|
    t.string "address", limit: 250
    t.string "address_type", limit: 100, null: false
    t.string "contact_person_name", limit: 100
    t.string "contact_person_number", limit: 20, null: false
    t.datetime "created_at", precision: nil
    t.string "floor", limit: 255
    t.string "house", limit: 255
    t.integer "is_guest", limit: 2, default: 0, null: false
    t.string "latitude", limit: 255
    t.string "longitude", limit: 255
    t.string "road", limit: 255
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: nil
    t.string "user_id", limit: 255
    t.index ["tenant_id"], name: "customer_addresses_tenant_id_index"
  end

  create_table "d_m_reviews", force: :cascade do |t|
    t.string "attachment", limit: 255
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.bigint "delivery_man_id", null: false
    t.bigint "order_id", null: false
    t.integer "rating", default: 0, null: false
    t.datetime "updated_at", precision: nil
    t.bigint "user_id", null: false
  end

  create_table "dc_conversations", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.bigint "order_id", null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "delivery_charge_by_areas", force: :cascade do |t|
    t.string "area_name", limit: 255, null: false
    t.integer "branch_id", null: false
    t.datetime "created_at", precision: 0
    t.float "delivery_charge", default: 0.0, null: false
    t.datetime "updated_at", precision: 0
    t.index ["branch_id"], name: "delivery_charge_by_areas_branch_id_index"
  end

  create_table "delivery_charge_setups", force: :cascade do |t|
    t.integer "branch_id", null: false
    t.datetime "created_at", precision: 0
    t.float "delivery_charge_per_kilometer", default: 0.0, null: false
    t.string "delivery_charge_type", limit: 255, default: "distance", null: false, comment: "area/distance"
    t.float "fixed_delivery_charge", default: 0.0, null: false
    t.float "minimum_delivery_charge", default: 0.0, null: false
    t.float "minimum_distance_for_free_delivery", default: 0.0, null: false
    t.datetime "updated_at", precision: 0
    t.index ["branch_id"], name: "delivery_charge_setups_branch_id_index"
  end

  create_table "delivery_histories", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "deliveryman_id"
    t.string "latitude", limit: 255
    t.string "location", limit: 255
    t.string "longitude", limit: 255
    t.bigint "order_id"
    t.datetime "time", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "delivery_men", force: :cascade do |t|
    t.string "application_status", limit: 255, default: "approved", null: false
    t.string "auth_token", limit: 255
    t.bigint "branch_id", default: 1, null: false
    t.datetime "created_at", precision: nil
    t.string "email", limit: 100
    t.string "f_name", limit: 100
    t.string "fcm_token", limit: 255
    t.text "identity_image"
    t.string "identity_number", limit: 30
    t.string "identity_type", limit: 50
    t.string "image", limit: 100
    t.integer "is_active", limit: 2, default: 1
    t.integer "is_temp_blocked", limit: 2, default: 0, null: false
    t.string "l_name", limit: 100
    t.string "language_code", limit: 255, default: "en", null: false
    t.integer "login_hit_count", limit: 2, default: 0, null: false
    t.string "password", limit: 100, null: false
    t.string "phone", limit: 20, null: false
    t.datetime "temp_block_time", precision: nil
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: nil
    t.index ["tenant_id"], name: "delivery_men_tenant_id_index"
    t.unique_constraint ["phone"], name: "delivery_men_phone_unique"
  end

  create_table "email_verifications", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "email", limit: 255
    t.integer "is_temp_blocked", limit: 2, default: 0, null: false
    t.integer "otp_hit_count", limit: 2, default: 0, null: false
    t.datetime "temp_block_time", precision: nil
    t.bigint "tenant_id"
    t.string "token", limit: 255
    t.datetime "updated_at", precision: nil
    t.index ["tenant_id"], name: "email_verifications_tenant_id_index"
  end

  create_table "failed_jobs", force: :cascade do |t|
    t.text "connection", null: false
    t.text "exception", null: false
    t.datetime "failed_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "payload", null: false
    t.text "queue", null: false
  end

  create_table "favorite_products", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.bigint "product_id", null: false
    t.datetime "updated_at", precision: 0
    t.bigint "user_id", null: false
  end

  create_table "flash_deal_products", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.float "discount", default: 0.0, null: false
    t.string "discount_type", limit: 255
    t.bigint "flash_deal_id"
    t.bigint "product_id"
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: 0
    t.index ["tenant_id"], name: "flash_deal_products_tenant_id_index"
  end

  create_table "flash_deals", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "deal_type", limit: 255
    t.date "end_date"
    t.uuid "external_id", null: false
    t.integer "featured", limit: 2, default: 0, null: false
    t.string "image", limit: 255
    t.date "start_date"
    t.integer "status", limit: 2, default: 0, null: false
    t.bigint "tenant_id"
    t.string "title", limit: 255
    t.datetime "updated_at", precision: 0
    t.index ["external_id"], name: "flash_deals_external_id_index"
    t.index ["tenant_id"], name: "flash_deals_tenant_id_index"
    t.unique_constraint ["external_id"], name: "flash_deals_external_id_unique"
  end

  create_table "guest_users", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "fcm_token", limit: 255
    t.string "ip_address", limit: 255
    t.string "language_code", limit: 255, default: "en", null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "jobs", force: :cascade do |t|
    t.integer "attempts", limit: 2, null: false
    t.integer "available_at", null: false
    t.integer "created_at", null: false
    t.text "payload", null: false
    t.string "queue", limit: 255, null: false
    t.integer "reserved_at"
    t.index ["queue"], name: "jobs_queue_index"
  end

  create_table "journal_entries", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.text "description", null: false
    t.date "entry_date", null: false
    t.string "entry_type", limit: 255, null: false
    t.string "journal_number", limit: 50, null: false
    t.datetime "posted_at", precision: 0
    t.bigint "posted_by"
    t.bigint "reference_id"
    t.string "reference_type", limit: 50
    t.string "reversal_reason", limit: 255
    t.datetime "reversed_at", precision: 0
    t.bigint "reversed_by"
    t.string "status", limit: 255, default: "draft", null: false
    t.bigint "tenant_id"
    t.decimal "total_credit", precision: 15, scale: 2, default: "0.0", null: false
    t.decimal "total_debit", precision: 15, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", precision: 0
    t.index ["reference_type", "reference_id"], name: "journal_entries_reference_type_reference_id_index"
    t.index ["status", "entry_date"], name: "journal_entries_status_entry_date_index"
    t.index ["tenant_id", "entry_date"], name: "journal_entries_tenant_id_entry_date_index"
    t.check_constraint "entry_type::text = ANY (ARRAY['order_payment'::character varying::text, 'commission_split'::character varying::text, 'payout'::character varying::text, 'refund'::character varying::text, 'adjustment'::character varying::text, 'subscription'::character varying::text, 'fee'::character varying::text])", name: "journal_entries_entry_type_check"
    t.check_constraint "status::text = ANY (ARRAY['draft'::character varying::text, 'posted'::character varying::text, 'reversed'::character varying::text])", name: "journal_entries_status_check"
    t.unique_constraint ["journal_number"], name: "journal_entries_journal_number_unique"
  end

  create_table "ledger_entries", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 0
    t.decimal "credit", precision: 15, scale: 2, default: "0.0", null: false
    t.string "currency", limit: 3, default: "BRL", null: false
    t.decimal "debit", precision: 15, scale: 2, default: "0.0", null: false
    t.bigint "journal_entry_id", null: false
    t.text "line_description"
    t.bigint "reference_id"
    t.string "reference_type", limit: 50
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: 0
    t.index ["created_at"], name: "ledger_entries_created_at_index"
    t.index ["journal_entry_id"], name: "ledger_entries_journal_entry_id_index"
    t.index ["reference_type", "reference_id"], name: "ledger_entries_reference_type_reference_id_index"
    t.index ["tenant_id", "account_id"], name: "ledger_entries_tenant_id_account_id_index"
  end

  create_table "login_setups", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "key", limit: 255
    t.datetime "updated_at", precision: 0
    t.text "value"
  end

  create_table "loyalty_transactions", force: :cascade do |t|
    t.decimal "balance", precision: 24, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: 0
    t.decimal "credit", precision: 24, scale: 2, default: "0.0", null: false
    t.decimal "debit", precision: 24, scale: 2, default: "0.0", null: false
    t.string "reference", limit: 191
    t.string "transaction_id", limit: 255
    t.string "transaction_type", limit: 191
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "attachment"
    t.bigint "conversation_id", null: false
    t.datetime "created_at", precision: 0
    t.bigint "customer_id"
    t.bigint "deliveryman_id"
    t.text "message"
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: 0
    t.index ["tenant_id"], name: "messages_tenant_id_index"
  end

  create_table "mfa_verifications", force: :cascade do |t|
    t.string "code", limit: 255, null: false
    t.datetime "created_at", precision: 0
    t.datetime "expires_at", precision: 0, null: false
    t.string "method", limit: 255, null: false
    t.datetime "updated_at", precision: 0
    t.bigint "user_id", null: false
    t.index ["expires_at"], name: "mfa_verifications_expires_at_index"
    t.index ["user_id", "code"], name: "mfa_verifications_user_id_code_index"
    t.check_constraint "method::text = ANY (ARRAY['email'::character varying::text, 'sms'::character varying::text, 'app'::character varying::text, 'whatsapp'::character varying::text])", name: "mfa_verifications_method_check"
  end

  create_table "migrations", id: :serial, force: :cascade do |t|
    t.integer "batch", null: false
    t.string "migration", limit: 191, null: false
  end

  create_table "newsletters", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "email", limit: 255, null: false
    t.uuid "external_id", null: false
    t.datetime "updated_at", precision: 0
    t.index ["external_id"], name: "newsletters_external_id_index"
    t.unique_constraint ["external_id"], name: "newsletters_external_id_unique"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description", limit: 255
    t.uuid "external_id", null: false
    t.string "image", limit: 50
    t.integer "status", limit: 2, default: 1, null: false
    t.bigint "tenant_id"
    t.string "title", limit: 100
    t.datetime "updated_at", precision: nil
    t.index ["external_id"], name: "notifications_external_id_index"
    t.index ["tenant_id"], name: "notifications_tenant_id_index"
    t.unique_constraint ["external_id"], name: "notifications_external_id_unique"
  end

  create_table "oauth_access_tokens", id: { type: :string, limit: 100 }, force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "created_at", precision: 0
    t.datetime "expires_at", precision: 0
    t.string "name", limit: 255
    t.boolean "revoked", null: false
    t.text "scopes"
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
    t.index ["user_id"], name: "oauth_access_tokens_user_id_index"
  end

  create_table "oauth_auth_codes", id: { type: :string, limit: 100 }, force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "expires_at", precision: 0
    t.boolean "revoked", null: false
    t.text "scopes"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "oauth_auth_codes_user_id_index"
  end

  create_table "oauth_clients", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "name", limit: 255, null: false
    t.boolean "password_client", null: false
    t.boolean "personal_access_client", null: false
    t.string "provider", limit: 255
    t.text "redirect", null: false
    t.boolean "revoked", null: false
    t.string "secret", limit: 100
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
    t.index ["user_id"], name: "oauth_clients_user_id_index"
  end

  create_table "oauth_device_codes", id: { type: :string, limit: 80 }, force: :cascade do |t|
    t.uuid "client_id", null: false
    t.datetime "expires_at", precision: 0
    t.datetime "last_polled_at", precision: 0
    t.boolean "revoked", null: false
    t.text "scopes", null: false
    t.datetime "user_approved_at", precision: 0
    t.string "user_code", limit: 8, null: false
    t.bigint "user_id"
    t.index ["client_id"], name: "oauth_device_codes_client_id_index"
    t.index ["user_id"], name: "oauth_device_codes_user_id_index"
    t.unique_constraint ["user_code"], name: "oauth_device_codes_user_code_unique"
  end

  create_table "oauth_personal_access_clients", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
  end

  create_table "oauth_refresh_tokens", id: { type: :string, limit: 100 }, force: :cascade do |t|
    t.string "access_token_id", limit: 100, null: false
    t.datetime "expires_at", precision: 0
    t.boolean "revoked", null: false
    t.index ["access_token_id"], name: "oauth_refresh_tokens_access_token_id_index"
  end

  create_table "offline_payment_methods", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.text "method_fields", null: false
    t.text "method_informations", null: false
    t.string "method_name", limit: 255, null: false
    t.string "payment_note", limit: 255
    t.integer "status", default: 1, null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: 0
    t.index ["tenant_id"], name: "offline_payment_methods_tenant_id_index"
  end

  create_table "offline_payments", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.bigint "order_id", null: false
    t.text "payment_info"
    t.integer "status", limit: 2, default: 0, null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "order_areas", force: :cascade do |t|
    t.bigint "area_id", null: false
    t.bigint "branch_id", null: false
    t.datetime "created_at", precision: 0
    t.bigint "order_id", null: false
    t.datetime "updated_at", precision: 0
    t.index ["area_id"], name: "order_areas_area_id_index"
    t.index ["branch_id"], name: "order_areas_branch_id_index"
    t.index ["order_id"], name: "order_areas_order_id_index"
  end

  create_table "order_delivery_histories", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "delivery_man_id"
    t.string "end_location", limit: 255
    t.datetime "end_time", precision: nil
    t.bigint "order_id"
    t.string "start_location", limit: 255
    t.datetime "start_time", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "order_detail_addons", force: :cascade do |t|
    t.bigint "addon_item_id"
    t.string "addon_item_name", limit: 255, null: false
    t.datetime "created_at", precision: 0
    t.bigint "order_detail_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.index ["addon_item_id"], name: "order_detail_addons_addon_item_id_index"
    t.index ["order_detail_id"], name: "order_detail_addons_order_detail_id_index"
  end

  create_table "order_details", force: :cascade do |t|
    t.decimal "addons_total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: nil
    t.date "delivery_date"
    t.decimal "discount_on_product", precision: 8, scale: 2
    t.string "discount_type", limit: 20, default: "amount", null: false
    t.integer "is_stock_decreased", limit: 2, default: 1, null: false
    t.bigint "order_id"
    t.decimal "price", precision: 8, scale: 2, default: "0.0", null: false
    t.text "product_details"
    t.bigint "product_id"
    t.integer "quantity", default: 1, null: false
    t.decimal "tax_amount", precision: 8, scale: 2, default: "1.0", null: false
    t.bigint "tenant_id"
    t.bigint "time_slot_id"
    t.string "unit", limit: 255, default: "pc", null: false
    t.datetime "updated_at", precision: nil
    t.string "variant", limit: 255
    t.string "variation", limit: 255
    t.string "vat_status", limit: 255, default: "excluded", null: false
    t.index ["tenant_id"], name: "order_details_tenant_id_index"
  end

  create_table "order_images", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "image", limit: 255
    t.bigint "order_id", null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "order_partial_payments", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.decimal "due_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "order_id", null: false
    t.decimal "paid_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "paid_with", limit: 255, null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: 0
    t.index ["tenant_id"], name: "order_partial_payments_tenant_id_index"
  end

  create_table "order_status_logs", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "from_status", limit: 50, null: false
    t.string "ip_address", limit: 45
    t.bigint "order_id", null: false
    t.string "reason", limit: 500
    t.string "to_status", limit: 50, null: false
    t.datetime "updated_at", precision: 0
    t.string "user_agent", limit: 500
    t.bigint "user_id"
    t.string "user_type", limit: 20, default: "system", null: false
    t.index ["from_status"], name: "order_status_logs_from_status_index"
    t.index ["order_id", "created_at"], name: "order_status_logs_order_id_created_at_index"
    t.index ["to_status"], name: "order_status_logs_to_status_index"
    t.index ["user_id"], name: "order_status_logs_user_id_index"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "branch_id", default: 1, null: false
    t.decimal "cadatech_commission", precision: 10, scale: 2, default: "0.0", null: false
    t.string "callback", limit: 255
    t.integer "checked", limit: 2, default: 0, null: false
    t.decimal "commission_rate", precision: 5, scale: 2, default: "0.0", null: false
    t.string "coupon_code", limit: 255
    t.decimal "coupon_discount_amount", precision: 8, scale: 2, default: "0.0", null: false
    t.string "coupon_discount_title", limit: 255
    t.datetime "created_at", precision: nil
    t.date "date"
    t.text "delivery_address"
    t.bigint "delivery_address_id"
    t.decimal "delivery_charge", precision: 8, scale: 2, default: "0.0", null: false
    t.json "delivery_config"
    t.date "delivery_date"
    t.bigint "delivery_man_id"
    t.string "delivery_managed_by", limit: 255, default: "cadatech", null: false
    t.uuid "external_id"
    t.decimal "extra_discount", precision: 8, scale: 2, default: "0.0", null: false
    t.float "free_delivery_amount", default: 0.0, null: false
    t.integer "is_guest", limit: 2, default: 0, null: false
    t.decimal "order_amount", precision: 8, scale: 2, default: "0.0", null: false
    t.text "order_note"
    t.string "order_status", limit: 255, default: "pending", null: false
    t.string "order_type", limit: 255, default: "delivery", null: false
    t.string "payment_by", limit: 255
    t.string "payment_method", limit: 30
    t.string "payment_note", limit: 255
    t.string "payment_status", limit: 255, default: "unpaid", null: false
    t.datetime "payout_date", precision: 0
    t.string "payout_reference", limit: 255
    t.string "payout_status", limit: 255, default: "pending", null: false
    t.decimal "platform_fee", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "subscriber_id", comment: "Assinante responsável pelo pedido"
    t.decimal "subscriber_revenue", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "tenant_id"
    t.bigint "time_slot_id"
    t.decimal "total_tax_amount", precision: 8, scale: 2, default: "0.0", null: false
    t.string "transaction_reference", limit: 30
    t.datetime "updated_at", precision: nil
    t.bigint "user_id"
    t.float "weight_charge_amount", default: 0.0, null: false
    t.index ["payout_status"], name: "orders_payout_status_index"
    t.index ["subscriber_id"], name: "orders_subscriber_id_index"
    t.index ["tenant_id"], name: "orders_tenant_id_index"
    t.check_constraint "delivery_managed_by::text = ANY (ARRAY['subscriber'::character varying::text, 'cadatech'::character varying::text])", name: "orders_delivery_managed_by_check"
    t.check_constraint "payout_status::text = ANY (ARRAY['pending'::character varying::text, 'processing'::character varying::text, 'completed'::character varying::text, 'failed'::character varying::text])", name: "orders_payout_status_check"
    t.unique_constraint ["external_id"], name: "orders_external_id_unique"
  end

  create_table "outbox_events", force: :cascade do |t|
    t.bigint "aggregate_id", null: false
    t.string "aggregate_type", limit: 50, null: false
    t.integer "attempts", limit: 2, default: 0, null: false
    t.datetime "created_at", precision: 0
    t.text "error_message"
    t.string "event_type", limit: 100, null: false
    t.json "payload", null: false
    t.datetime "processed_at", precision: 0
    t.string "status", limit: 20, default: "pending", null: false
    t.datetime "updated_at", precision: 0
    t.index ["aggregate_type", "aggregate_id"], name: "outbox_events_aggregate_type_aggregate_id_index"
    t.index ["status", "created_at"], name: "outbox_events_status_created_at_index"
    t.index ["status", "processed_at"], name: "outbox_events_status_processed_at_index"
  end

  create_table "password_resets", id: false, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "email_or_phone", limit: 255, null: false
    t.datetime "expires_at", precision: nil
    t.integer "is_temp_blocked", limit: 2, default: 0, null: false
    t.integer "otp_hit_count", limit: 2, default: 0, null: false
    t.datetime "temp_block_time", precision: nil
    t.string "token", limit: 255, null: false
    t.string "token_hash", limit: 64
    t.integer "used", limit: 2, default: 0, null: false
    t.index ["expires_at", "used"], name: "password_resets_expires_at_used_index"
  end

  create_table "payment_reconciliations", force: :cascade do |t|
    t.uuid "batch_id", null: false, comment: "Groups records from same reconciliation run"
    t.datetime "created_at", precision: 0
    t.string "currency", limit: 10, default: "BRL", null: false
    t.string "gateway", limit: 50, null: false, comment: "Payment gateway: stripe, paypal, mercadopago"
    t.decimal "gateway_amount", precision: 24, scale: 2, comment: "Amount reported by gateway"
    t.json "gateway_data", comment: "Raw data from gateway API"
    t.string "gateway_status", limit: 50, comment: "Status from gateway API"
    t.string "gateway_transaction_id", limit: 255, comment: "Transaction ID from gateway"
    t.decimal "local_amount", precision: 24, scale: 2, comment: "Amount in our PaymentRequest"
    t.json "local_data", comment: "PaymentRequest data snapshot"
    t.boolean "local_is_paid", comment: "is_paid from PaymentRequest"
    t.string "local_transaction_id", limit: 255, comment: "PaymentRequest ID in our system"
    t.date "reconciliation_date", null: false, comment: "Date being reconciled"
    t.text "resolution_notes"
    t.string "resolution_status", limit: 255, default: "pending", null: false
    t.datetime "resolved_at", precision: 0
    t.bigint "resolved_by"
    t.string "status", limit: 255, null: false
    t.datetime "updated_at", precision: 0
    t.index ["batch_id", "status"], name: "payment_reconciliations_batch_id_status_index"
    t.index ["batch_id"], name: "payment_reconciliations_batch_id_index"
    t.index ["gateway", "reconciliation_date", "status"], name: "payment_reconciliations_gateway_reconciliation_date_status_inde"
    t.index ["gateway"], name: "payment_reconciliations_gateway_index"
    t.index ["reconciliation_date"], name: "payment_reconciliations_reconciliation_date_index"
    t.index ["resolution_status"], name: "payment_reconciliations_resolution_status_index"
    t.index ["status"], name: "payment_reconciliations_status_index"
    t.check_constraint "resolution_status::text = ANY (ARRAY['pending'::character varying::text, 'investigating'::character varying::text, 'resolved'::character varying::text, 'ignored'::character varying::text])", name: "payment_reconciliations_resolution_status_check"
    t.check_constraint "status::text = ANY (ARRAY['matched'::character varying::text, 'missing_local'::character varying::text, 'missing_gateway'::character varying::text, 'amount_mismatch'::character varying::text, 'status_mismatch'::character varying::text])", name: "payment_reconciliations_status_check"
  end

  create_table "payment_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "additional_data"
    t.string "attribute", limit: 255
    t.string "attribute_id", limit: 64
    t.datetime "created_at", precision: nil
    t.string "currency_code", limit: 20, default: "USD", null: false
    t.string "external_redirect_link", limit: 255
    t.string "failure_hook", limit: 100
    t.string "gateway_callback_url", limit: 191
    t.integer "is_paid", limit: 2, default: 0, null: false
    t.string "payer_id", limit: 64
    t.text "payer_information"
    t.decimal "payment_amount", precision: 24, scale: 2, default: "0.0", null: false
    t.string "payment_method", limit: 50
    t.string "payment_platform", limit: 255
    t.string "receiver_id", limit: 64
    t.text "receiver_information"
    t.string "success_hook", limit: 100
    t.string "transaction_id", limit: 100
    t.datetime "updated_at", precision: nil
  end

  create_table "pending_registrations", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "email", limit: 255
    t.datetime "expires_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "f_name", limit: 255, null: false
    t.string "l_name", limit: 255, null: false
    t.string "language_code", limit: 10, default: "en", null: false
    t.string "password", limit: 255, null: false
    t.string "phone", limit: 255, null: false
    t.string "referral_code", limit: 20
    t.bigint "referred_by"
    t.bigint "subscription_plan_id"
    t.string "temporary_token", limit: 100, null: false
    t.string "tenant_slug", limit: 255
    t.datetime "updated_at", precision: nil
    t.string "website", limit: 255
    t.string "whatsapp", limit: 20

    t.unique_constraint ["phone"], name: "pending_registrations_phone_unique"
    t.unique_constraint ["temporary_token"], name: "pending_registrations_temporary_token_unique"
  end

  create_table "phone_verifications", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.boolean "is_temp_blocked", default: false, null: false
    t.integer "otp_hit_count", limit: 2, default: 0, null: false
    t.string "phone", limit: 255
    t.datetime "temp_block_time", precision: 0
    t.bigint "tenant_id"
    t.string "token", limit: 255
    t.datetime "updated_at", precision: 0
    t.index ["tenant_id"], name: "phone_verifications_tenant_id_index"
  end

  create_table "product_addon_groups", force: :cascade do |t|
    t.bigint "addon_group_id", null: false
    t.datetime "created_at", precision: 0
    t.integer "order", default: 0, null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", precision: 0
    t.index ["addon_group_id"], name: "product_addon_groups_addon_group_id_index"
    t.index ["product_id"], name: "product_addon_groups_product_id_index"
    t.unique_constraint ["product_id", "addon_group_id"], name: "product_addon_groups_product_id_addon_group_id_unique"
  end

  create_table "product_searched_by_user", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.bigint "product_id"
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
  end

  create_table "product_tag", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "tag_id", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "affiliate", limit: 255, default: "nenhum"
    t.string "affiliate_link", limit: 255
    t.text "approval_notes", comment: "Observações da aprovação/reprovação"
    t.string "approval_status", limit: 255, default: "pending", null: false
    t.datetime "approved_at", precision: 0
    t.bigint "approved_by"
    t.string "attributes", limit: 255
    t.boolean "cadatech_approved", default: false, null: false
    t.decimal "capacity", precision: 8, scale: 2
    t.string "category_ids", limit: 255
    t.text "choice_options"
    t.datetime "created_at", precision: nil
    t.decimal "custom_commission_rate", precision: 5, scale: 2, comment: "Comissão personalizada para este produto"
    t.integer "daily_needs", limit: 2, default: 0, null: false
    t.json "delivery_config", comment: "Configurações específicas de entrega"
    t.string "delivery_managed_by", limit: 255, default: "cadatech", null: false
    t.text "description"
    t.decimal "discount", precision: 8, scale: 2, default: "0.0", null: false
    t.string "discount_type", limit: 20, default: "percent", null: false
    t.string "external_link", limit: 500
    t.string "fixed_uuid", limit: 36
    t.text "image"
    t.json "installments_config", comment: "JSON configuration for credit card installments"
    t.integer "is_featured", limit: 2, default: 0, null: false
    t.integer "maximum_order_quantity", default: 10, null: false
    t.string "name", limit: 255
    t.integer "popularity_count", default: 0, null: false
    t.float "price", default: 0.0, null: false
    t.string "public_id", limit: 26
    t.string "public_uuid", limit: 36
    t.datetime "qr_code_generated_at", precision: nil
    t.string "qr_code_path", limit: 255
    t.string "slug", limit: 255
    t.datetime "slug_normalized_at", precision: nil
    t.integer "status", limit: 2, default: 1, null: false
    t.boolean "stock_controlled", default: true, null: false
    t.string "stock_type", limit: 20, default: "unlimited", null: false
    t.bigint "subscriber_id", comment: "ID do assinante dono do produto"
    t.integer "subscriber_sales", default: 0, null: false
    t.string "subscriber_status", limit: 255, default: "active", null: false
    t.integer "subscriber_views", default: 0, null: false
    t.text "tags"
    t.decimal "tax", precision: 8, scale: 2, default: "0.0", null: false
    t.string "tax_type", limit: 20, default: "percent", null: false
    t.bigint "tenant_id"
    t.bigint "total_stock", default: 0, null: false
    t.string "unit", limit: 255, default: "pc", null: false
    t.datetime "updated_at", precision: nil
    t.text "variations"
    t.integer "view_count", default: 0, null: false
    t.float "weight", default: 0.0, null: false
    t.index ["approval_status"], name: "products_approval_status_index"
    t.index ["cadatech_approved"], name: "products_cadatech_approved_index"
    t.index ["subscriber_id"], name: "products_subscriber_id_index"
    t.check_constraint "approval_status::text = ANY (ARRAY['pending'::character varying::text, 'approved'::character varying::text, 'rejected'::character varying::text, 'changes_requested'::character varying::text])", name: "products_approval_status_check"
    t.check_constraint "delivery_managed_by::text = ANY (ARRAY['subscriber'::character varying::text, 'cadatech'::character varying::text])", name: "products_delivery_managed_by_check"
    t.check_constraint "subscriber_status::text = ANY (ARRAY['active'::character varying::text, 'inactive'::character varying::text])", name: "products_subscriber_status_check"
    t.unique_constraint ["fixed_uuid"], name: "products_fixed_uuid_unique"
    t.unique_constraint ["public_id"], name: "products_public_id_unique"
    t.unique_constraint ["public_uuid"], name: "products_public_uuid_unique"
  end

  create_table "recent_searches", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "keyword", limit: 255
    t.datetime "updated_at", precision: 0
  end

  create_table "register_devices", force: :cascade do |t|
    t.string "browser_name", limit: 255
    t.string "browser_version", limit: 255
    t.datetime "created_at", precision: 0
    t.string "device_platform", limit: 255
    t.string "device_type", limit: 255
    t.string "ip_address", limit: 255
    t.string "is_robot", limit: 255, default: "0", null: false
    t.string "unique_identifier", limit: 255, null: false
    t.datetime "updated_at", precision: 0
    t.integer "user_id", null: false
    t.string "user_type", limit: 255, null: false
  end

  create_table "register_invites", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "created_by", limit: 255, comment: "Admin name or system identifier"
    t.string "email", limit: 255, comment: "Optional: restrict invite to specific email"
    t.datetime "expires_at", precision: 0, null: false
    t.text "notes", comment: "Optional: reason for invite"
    t.string "token", limit: 64, null: false
    t.datetime "updated_at", precision: 0
    t.datetime "used_at", precision: 0
    t.index ["expires_at"], name: "register_invites_expires_idx"
    t.unique_constraint ["token"], name: "register_invites_token_unique"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "attachment", limit: 255
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.integer "is_active", limit: 2, default: 1, null: false
    t.bigint "order_id"
    t.bigint "product_id", null: false
    t.integer "rating", default: 0, null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: nil
    t.bigint "user_id", null: false
    t.index ["tenant_id"], name: "reviews_tenant_id_index"
  end

  create_table "searched_categories", force: :cascade do |t|
    t.bigint "category_id"
    t.datetime "created_at", precision: 0
    t.bigint "recent_search_id"
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
  end

  create_table "searched_data", force: :cascade do |t|
    t.string "attribute", limit: 255
    t.bigint "attribute_id"
    t.bigint "category_id"
    t.datetime "created_at", precision: 0
    t.integer "response_data_count", default: 0, null: false
    t.datetime "updated_at", precision: 0
    t.bigint "user_id", null: false
    t.integer "volume", default: 0, null: false
  end

  create_table "searched_keyword_counts", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.integer "keyword_count", default: 0, null: false
    t.bigint "recent_search_id"
    t.datetime "updated_at", precision: 0
  end

  create_table "searched_keyword_users", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.bigint "recent_search_id"
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
  end

  create_table "searched_products", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.bigint "product_id"
    t.bigint "recent_search_id"
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "billing_unit", limit: 255
    t.string "category_ids", limit: 255
    t.datetime "created_at", precision: 0
    t.text "description"
    t.decimal "discount", precision: 8, scale: 2, default: "0.0", null: false
    t.string "discount_type", limit: 20, default: "percent", null: false
    t.string "duration", limit: 255, comment: "Duration in minutes"
    t.json "extra_fields"
    t.text "image"
    t.boolean "is_featured", default: false, null: false
    t.boolean "is_visible", default: true, null: false
    t.integer "max_quantity"
    t.integer "min_quantity"
    t.string "name", limit: 255, null: false
    t.integer "popularity_count", default: 0, null: false
    t.float "price", default: 0.0, null: false
    t.integer "status", limit: 2, default: 1, null: false
    t.decimal "tax", precision: 8, scale: 2, default: "0.0", null: false
    t.string "tax_type", limit: 20, default: "percent", null: false
    t.string "type", limit: 255, default: "fixed", null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "sessions", id: { type: :string, limit: 255 }, force: :cascade do |t|
    t.string "ip_address", limit: 45
    t.integer "last_activity", null: false
    t.text "payload", null: false
    t.text "user_agent"
    t.bigint "user_id"
    t.index ["last_activity"], name: "sessions_last_activity_index"
    t.index ["user_id"], name: "sessions_user_id_index"
  end

  create_table "social_medias", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "link", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.boolean "status", default: true, null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "soft_credentials", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "key", limit: 255
    t.datetime "updated_at", precision: nil
    t.text "value"
  end

  create_table "stock_reservations", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.datetime "expires_at", precision: 0, null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.string "session_identifier", limit: 255, null: false, comment: "user_id or guest session identifier"
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: 0
    t.string "variation_type", limit: 255, comment: "For variant products, matches variations JSON type field"
    t.index ["expires_at"], name: "stock_res_expires_idx"
    t.index ["product_id", "variation_type"], name: "stock_res_product_variation_idx"
    t.index ["session_identifier"], name: "stock_res_session_idx"
    t.index ["tenant_id"], name: "stock_res_tenant_idx"
  end

  create_table "stores", force: :cascade do |t|
    t.string "address", limit: 255
    t.string "address_number", limit: 20
    t.string "banner", limit: 255
    t.date "birth_date"
    t.string "city", limit: 100
    t.string "cnpj", limit: 18
    t.decimal "commission_rate", precision: 5, scale: 2
    t.string "complement", limit: 100
    t.string "country", limit: 2, default: "BR", null: false
    t.string "cpf", limit: 14
    t.datetime "created_at", precision: 0
    t.text "description"
    t.string "email", limit: 255
    t.uuid "external_id", null: false
    t.string "inscricao_estadual", limit: 20
    t.string "inscricao_municipal", limit: 20
    t.string "logo", limit: 255
    t.string "name", limit: 255, null: false
    t.string "neighborhood", limit: 100
    t.string "nome_fantasia", limit: 255
    t.string "person_type", limit: 255
    t.string "phone", limit: 20
    t.string "postal_code", limit: 10
    t.boolean "profile_completed", default: false, null: false
    t.string "razao_social", limit: 255
    t.string "rg", limit: 20
    t.json "settings"
    t.string "slug", limit: 100, null: false
    t.string "state", limit: 2
    t.string "status", limit: 255, default: "active", null: false
    t.bigint "tenant_id", null: false
    t.json "theme"
    t.decimal "total_commission_earned", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "total_commission_paid", precision: 12, scale: 2, default: "0.0", null: false
    t.integer "total_orders", default: 0, null: false
    t.integer "total_products", default: 0, null: false
    t.decimal "total_sales", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", precision: 0
    t.string "website", limit: 255
    t.string "whatsapp", limit: 20
    t.index ["person_type"], name: "stores_person_type_index"
    t.index ["status"], name: "stores_status_index"
    t.check_constraint "person_type::text = ANY (ARRAY['pf'::character varying, 'pj'::character varying]::text[])", name: "stores_person_type_check"
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying, 'inactive'::character varying, 'suspended'::character varying]::text[])", name: "stores_status_check"
    t.unique_constraint ["cnpj"], name: "stores_cnpj_unique"
    t.unique_constraint ["cpf"], name: "stores_cpf_unique"
    t.unique_constraint ["external_id"], name: "stores_external_id_unique"
    t.unique_constraint ["slug"], name: "stores_slug_unique"
    t.unique_constraint ["tenant_id"], name: "stores_tenant_id_unique"
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.boolean "advanced_analytics", default: false, null: false
    t.boolean "api_access", default: false, null: false
    t.decimal "commission_rate", precision: 5, scale: 2, null: false, comment: "Taxa de comissão padrão"
    t.datetime "created_at", precision: 0
    t.boolean "custom_domain", default: false, null: false
    t.boolean "delivery_management", default: false, null: false
    t.text "description"
    t.uuid "external_id", null: false
    t.boolean "featured_listing", default: false, null: false, comment: "Listagem em destaque"
    t.json "features"
    t.boolean "is_active", default: true, null: false
    t.boolean "is_featured", default: false, null: false
    t.integer "max_monthly_orders", comment: "Limite de pedidos mensais"
    t.integer "max_products", comment: "NULL = ilimitado"
    t.integer "max_services", comment: "NULL = ilimitado"
    t.integer "max_storage_mb", default: 1024, null: false, comment: "Limite de armazenamento em MB"
    t.string "name", limit: 100, null: false
    t.decimal "price_monthly", precision: 10, scale: 2, null: false, comment: "Preço mensal"
    t.decimal "price_yearly", precision: 10, scale: 2, comment: "Preço anual com desconto"
    t.boolean "priority_support", default: false, null: false
    t.boolean "seo_tools", default: false, null: false
    t.decimal "setup_fee", precision: 10, scale: 2, default: "0.0", null: false, comment: "Taxa de configuração"
    t.string "slug", limit: 100, null: false
    t.boolean "social_media_integration", default: false, null: false
    t.integer "sort_order", default: 0, null: false
    t.string "status", limit: 255, default: "active", null: false
    t.decimal "transaction_fee", precision: 5, scale: 2, default: "0.0", null: false, comment: "Taxa por transação"
    t.integer "trial_days", default: 7, null: false
    t.boolean "trial_enabled", default: true, null: false
    t.datetime "updated_at", precision: 0
    t.boolean "white_label", default: false, null: false
    t.index ["external_id"], name: "subscription_plans_external_id_index"
    t.index ["slug"], name: "subscription_plans_slug_index"
    t.index ["sort_order"], name: "subscription_plans_sort_order_index"
    t.index ["status"], name: "subscription_plans_status_index"
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying::text, 'inactive'::character varying::text, 'archived'::character varying::text])", name: "subscription_plans_status_check"
    t.unique_constraint ["external_id"], name: "subscription_plans_external_id_unique"
    t.unique_constraint ["slug"], name: "subscription_plans_slug_unique"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "billing_cycle", limit: 255
    t.datetime "cancelled_at", precision: 0
    t.bigint "changed_by"
    t.datetime "created_at", precision: 0
    t.datetime "ends_at", precision: 0
    t.uuid "external_id", null: false
    t.text "notes"
    t.string "payment_method", limit: 50
    t.string "payment_reference", limit: 255
    t.decimal "price_paid", precision: 10, scale: 2
    t.datetime "started_at", precision: 0
    t.string "status", limit: 255, default: "trial", null: false
    t.bigint "store_id", null: false
    t.bigint "subscription_plan_id", null: false
    t.datetime "suspended_at", precision: 0
    t.datetime "trial_ends_at", precision: 0
    t.datetime "updated_at", precision: 0
    t.index ["ends_at"], name: "subscriptions_ends_at_index"
    t.index ["status"], name: "subscriptions_status_index"
    t.index ["store_id", "status"], name: "subscriptions_store_id_status_index"
    t.index ["subscription_plan_id"], name: "subscriptions_subscription_plan_id_index"
    t.index ["trial_ends_at"], name: "subscriptions_trial_ends_at_index"
    t.check_constraint "billing_cycle::text = ANY (ARRAY['monthly'::character varying, 'yearly'::character varying]::text[])", name: "subscriptions_billing_cycle_check"
    t.check_constraint "status::text = ANY (ARRAY['trial'::character varying, 'active'::character varying, 'suspended'::character varying, 'cancelled'::character varying, 'expired'::character varying]::text[])", name: "subscriptions_status_check"
    t.unique_constraint ["external_id"], name: "subscriptions_external_id_unique"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.string "tag", limit: 255, null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "telescope_entries", primary_key: "sequence", force: :cascade do |t|
    t.uuid "batch_id", null: false
    t.text "content", null: false
    t.datetime "created_at", precision: 0
    t.string "family_hash", limit: 255
    t.boolean "should_display_on_index", default: true, null: false
    t.string "type", limit: 20, null: false
    t.uuid "uuid", null: false
    t.index ["batch_id"], name: "telescope_entries_batch_id_index"
    t.index ["created_at"], name: "telescope_entries_created_at_index"
    t.index ["family_hash"], name: "telescope_entries_family_hash_index"
    t.index ["type", "should_display_on_index"], name: "telescope_entries_type_should_display_on_index_index"
    t.unique_constraint ["uuid"], name: "telescope_entries_uuid_unique"
  end

  create_table "telescope_entries_tags", primary_key: ["entry_uuid", "tag"], force: :cascade do |t|
    t.uuid "entry_uuid", null: false
    t.string "tag", limit: 255, null: false
    t.index ["tag"], name: "telescope_entries_tags_tag_index"
  end

  create_table "telescope_monitoring", primary_key: "tag", id: { type: :string, limit: 255 }, force: :cascade do |t|
  end

  create_table "tenant_api_credentials", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "client_id", limit: 255, null: false
    t.text "client_secret_encrypted", null: false
    t.json "config"
    t.datetime "created_at", precision: 0
    t.datetime "expires_at", precision: 0
    t.string "provider", limit: 255, default: "mercancy_api", null: false
    t.json "scopes"
    t.bigint "tenant_id", null: false
    t.datetime "updated_at", precision: 0
    t.index ["tenant_id", "active"], name: "tenant_api_credentials_tenant_id_active_index"
    t.unique_constraint ["tenant_id", "provider"], name: "tenant_api_credentials_tenant_id_provider_unique"
  end

  create_table "tenant_api_tokens", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.datetime "expires_at", precision: 0, null: false
    t.datetime "last_used_at", precision: 0
    t.bigint "tenant_api_credential_id", null: false
    t.string "token_hash", limit: 255, null: false
    t.datetime "updated_at", precision: 0
    t.index ["tenant_api_credential_id", "expires_at"], name: "tenant_api_tokens_tenant_api_credential_id_expires_at_index"
  end

  create_table "tenant_settings", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.boolean "api_access_enabled", default: false, null: false
    t.string "api_key", limit: 64
    t.string "background_color", limit: 7
    t.string "billing_cycle", limit: 255, default: "monthly", null: false
    t.text "business_address"
    t.string "business_document", limit: 50
    t.string "business_email", limit: 255
    t.string "business_name", limit: 255
    t.string "business_phone", limit: 50
    t.string "card_background_color", limit: 7
    t.datetime "created_at", precision: 0
    t.string "currency", limit: 3, default: "BRL", null: false
    t.integer "current_products_count", default: 0, null: false
    t.integer "current_services_count", default: 0, null: false
    t.integer "current_storage_mb", default: 0, null: false
    t.string "custom_domain", limit: 255
    t.boolean "custom_domain_verified", default: false, null: false
    t.json "custom_settings"
    t.decimal "default_shipping_fee", precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "deleted_at", precision: 0
    t.json "disabled_features"
    t.json "email_settings"
    t.json "enabled_features"
    t.uuid "external_id", null: false
    t.string "facebook_page", limit: 500
    t.string "facebook_pixel_id", limit: 50
    t.string "favicon_url", limit: 500
    t.json "firebase_config"
    t.string "footer_color", limit: 7
    t.string "footer_text_color", limit: 7
    t.boolean "free_shipping_enabled", default: false, null: false
    t.decimal "free_shipping_minimum", precision: 8, scale: 2
    t.string "google_analytics_id", limit: 50
    t.string "header_color", limit: 7
    t.string "header_text_color", limit: 7
    t.string "instagram_handle", limit: 100
    t.string "locale", limit: 10, default: "pt_BR", null: false
    t.string "login_bg_image_url", limit: 500
    t.string "login_subtitle", limit: 500
    t.string "login_title", limit: 255
    t.string "logo_url", limit: 500
    t.text "maintenance_message"
    t.boolean "maintenance_mode", default: false, null: false
    t.integer "max_products"
    t.integer "max_services"
    t.integer "max_storage_mb"
    t.text "notes"
    t.boolean "notifications_enabled", default: true, null: false
    t.json "payment_gateways"
    t.json "pix_settings"
    t.string "primary_color", limit: 7
    t.boolean "push_notifications_enabled", default: false, null: false
    t.string "secondary_color", limit: 7
    t.json "shipping_methods"
    t.json "sms_settings"
    t.date "subscription_ends_at"
    t.bigint "subscription_plan_id"
    t.date "subscription_starts_at"
    t.string "subscription_status", limit: 255, default: "trial", null: false
    t.bigint "tenant_id", null: false
    t.string "text_color", limit: 7
    t.string "timezone", limit: 50, default: "America/Sao_Paulo", null: false
    t.date "trial_ends_at"
    t.datetime "updated_at", precision: 0
    t.json "webhook_urls"
    t.string "whatsapp_number", limit: 50
    t.index ["active"], name: "tenant_settings_active_index"
    t.index ["custom_domain"], name: "tenant_settings_custom_domain_index"
    t.index ["external_id"], name: "tenant_settings_external_id_index"
    t.index ["subscription_plan_id"], name: "tenant_settings_subscription_plan_id_index"
    t.index ["subscription_status"], name: "tenant_settings_subscription_status_index"
    t.check_constraint "billing_cycle::text = ANY (ARRAY['monthly'::character varying::text, 'yearly'::character varying::text])", name: "tenant_settings_billing_cycle_check"
    t.check_constraint "subscription_status::text = ANY (ARRAY['trial'::character varying::text, 'active'::character varying::text, 'suspended'::character varying::text, 'cancelled'::character varying::text, 'expired'::character varying::text])", name: "tenant_settings_subscription_status_check"
    t.unique_constraint ["api_key"], name: "tenant_settings_api_key_unique"
    t.unique_constraint ["external_id"], name: "tenant_settings_external_id_unique"
    t.unique_constraint ["tenant_id"], name: "tenant_settings_tenant_id_unique"
  end

  create_table "tenants", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: nil
    t.string "db_schema", limit: 100
    t.string "domain", limit: 255
    t.string "external_id", limit: 255
    t.string "name", limit: 255, null: false
    t.jsonb "settings"
    t.string "slug", limit: 255, null: false
    t.datetime "updated_at", precision: nil
    t.index ["active"], name: "tenants_active_index"
    t.index ["db_schema"], name: "tenants_db_schema_index"
    t.index ["slug"], name: "tenants_slug_index"
    t.unique_constraint ["slug"], name: "tenants_slug_key"
  end

  create_table "time_slots", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.date "date"
    t.time "end_time", precision: 0
    t.time "start_time", precision: 0
    t.boolean "status", default: true, null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: 0
    t.index ["tenant_id"], name: "time_slots_tenant_id_index"
  end

  create_table "track_deliverymen", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "delivery_man_id"
    t.string "latitude", limit: 20
    t.string "longitude", limit: 20
    t.bigint "order_id"
    t.datetime "updated_at", precision: nil
  end

  create_table "translations", force: :cascade do |t|
    t.string "key", limit: 255
    t.string "locale", limit: 255, null: false
    t.bigint "translationable_id", null: false
    t.string "translationable_type", limit: 255, null: false
    t.text "value"
    t.index ["locale"], name: "translations_locale_index"
    t.index ["translationable_id"], name: "translations_translationable_id_index"
  end

  create_table "users", force: :cascade do |t|
    t.text "address"
    t.date "birth_date"
    t.string "city", limit: 100
    t.string "cm_firebase_token", limit: 255
    t.string "cpf", limit: 14
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: 0
    t.string "email", limit: 100
    t.string "email_verification_token", limit: 255
    t.datetime "email_verified_at", precision: nil
    t.uuid "external_id", null: false
    t.string "f_name", limit: 100
    t.string "image", limit: 100
    t.integer "is_block", limit: 2, default: 0, null: false
    t.integer "is_phone_verified", limit: 2, default: 0, null: false
    t.integer "is_temp_blocked", limit: 2, default: 0, null: false
    t.string "l_name", limit: 100
    t.string "language_code", limit: 255, default: "en", null: false
    t.integer "login_hit_count", limit: 2, default: 0, null: false
    t.string "login_medium", limit: 255, default: "general", null: false
    t.float "loyalty_point", default: 0.0, null: false
    t.text "mfa_backup_codes"
    t.integer "mfa_enabled", limit: 2, default: 0, null: false
    t.string "mfa_secret", limit: 255
    t.string "mfa_totp_secret", limit: 255
    t.datetime "mfa_verified_at", precision: nil
    t.string "password", limit: 100, null: false
    t.string "phone", limit: 255
    t.string "referral_code", limit: 255
    t.string "referred_by", limit: 255
    t.string "remember_token", limit: 100
    t.string "state", limit: 2
    t.datetime "temp_block_time", precision: nil
    t.string "temporary_token", limit: 255
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: nil
    t.float "wallet_balance", default: 0.0, null: false
    t.string "zip_code", limit: 10
    t.index ["external_id"], name: "users_external_id_idx"
    t.index ["tenant_id"], name: "users_tenant_id_index"
    t.unique_constraint ["external_id"], name: "users_external_id_unique"
  end

  create_table "visited_products", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.bigint "product_id"
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
  end

  create_table "wallet_bonuses", force: :cascade do |t|
    t.float "bonus_amount", default: 0.0, null: false
    t.string "bonus_type", limit: 255, null: false
    t.datetime "created_at", precision: 0
    t.string "description", limit: 255
    t.date "end_date"
    t.float "maximum_bonus_amount", default: 0.0, null: false
    t.float "minimum_add_amount", default: 0.0, null: false
    t.date "start_date"
    t.boolean "status", default: true, null: false
    t.string "title", limit: 255, null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "wallet_transactions", force: :cascade do |t|
    t.decimal "balance", precision: 24, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: 0
    t.decimal "credit", precision: 24, scale: 2, default: "0.0", null: false
    t.decimal "debit", precision: 24, scale: 2, default: "0.0", null: false
    t.string "reference", limit: 191
    t.bigint "tenant_id"
    t.string "transaction_id", limit: 255
    t.string "transaction_type", limit: 191
    t.datetime "updated_at", precision: 0
    t.bigint "user_id"
    t.index ["tenant_id"], name: "wallet_transactions_tenant_id_index"
  end

  create_table "webhook_payloads", force: :cascade do |t|
    t.integer "attempts", limit: 2, default: 0, null: false
    t.datetime "completed_at", precision: 0
    t.datetime "created_at", precision: 0
    t.json "error_history"
    t.string "event_type", limit: 100
    t.string "external_id", limit: 255
    t.string "gateway", limit: 50, null: false
    t.json "headers"
    t.string "ip_address", limit: 45
    t.datetime "last_attempt_at", precision: 0
    t.text "last_error"
    t.integer "max_attempts", limit: 2, default: 5, null: false
    t.datetime "next_retry_at", precision: 0
    t.json "payload", null: false
    t.string "status", limit: 255, default: "pending", null: false
    t.datetime "updated_at", precision: 0
    t.uuid "uuid", null: false
    t.index ["external_id"], name: "webhook_payloads_external_id_index"
    t.index ["gateway"], name: "webhook_payloads_gateway_index"
    t.index ["next_retry_at"], name: "webhook_payloads_next_retry_at_index"
    t.index ["status", "next_retry_at"], name: "webhook_payloads_status_next_retry_at_index"
    t.index ["status"], name: "webhook_payloads_status_index"
    t.check_constraint "status::text = ANY (ARRAY['pending'::character varying::text, 'processing'::character varying::text, 'completed'::character varying::text, 'failed'::character varying::text, 'dead_letter'::character varying::text])", name: "webhook_payloads_status_check"
    t.unique_constraint ["uuid"], name: "webhook_payloads_uuid_unique"
  end

  create_table "weight_settings", force: :cascade do |t|
    t.bigint "branch_id", null: false
    t.datetime "created_at", precision: 0
    t.string "key", limit: 255
    t.string "type", limit: 255
    t.datetime "updated_at", precision: 0
    t.text "value"
    t.index ["branch_id"], name: "weight_settings_branch_id_index"
  end

  create_table "wishlists", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "product_id", null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", precision: nil
    t.bigint "user_id", null: false
    t.index ["tenant_id"], name: "wishlists_tenant_id_index"
  end

  add_foreign_key "addon_groups", "tenants", name: "addon_groups_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "addon_items", "addon_groups", name: "addon_items_addon_group_id_foreign", on_delete: :cascade
  add_foreign_key "admin_mfa_verifications", "admins", name: "admin_mfa_verifications_admin_id_foreign", on_delete: :cascade
  add_foreign_key "admin_sessions", "cadatech_admins", column: "admin_id"
  add_foreign_key "admins", "stores", name: "admins_store_id_foreign", on_delete: :nullify
  add_foreign_key "admins", "tenants", name: "admins_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "attribute_fields", "attributes", name: "attribute_fields_attribute_id_foreign", on_delete: :cascade
  add_foreign_key "attributes", "tenants", name: "attributes_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "banners", "tenants", name: "banners_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "branch_business_hours", "branches", name: "branch_business_hours_branch_id_foreign", on_delete: :cascade
  add_foreign_key "branches", "tenants", name: "branches_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "cadatech_admins", "cadatech_admins", column: "created_by", name: "cadatech_admins_created_by_foreign", on_delete: :nullify
  add_foreign_key "categories", "tenants", name: "categories_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "category_discounts", "tenants", name: "category_discounts_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "category_searched_by_user", "users", name: "category_searched_by_user_user_id_foreign", on_delete: :cascade
  add_foreign_key "conversations", "tenants", name: "conversations_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "coupons", "tenants", name: "coupons_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "customer_addresses", "tenants", name: "customer_addresses_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "delivery_men", "tenants", name: "delivery_men_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "email_verifications", "tenants", name: "email_verifications_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "favorite_products", "users", name: "favorite_products_user_id_foreign", on_delete: :cascade
  add_foreign_key "flash_deal_products", "tenants", name: "flash_deal_products_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "flash_deals", "tenants", name: "flash_deals_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "ledger_entries", "chart_of_accounts", column: "account_id", name: "ledger_entries_account_id_foreign", on_delete: :cascade
  add_foreign_key "ledger_entries", "journal_entries", name: "ledger_entries_journal_entry_id_foreign", on_delete: :cascade
  add_foreign_key "messages", "tenants", name: "messages_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "mfa_verifications", "users", name: "mfa_verifications_user_id_foreign", on_delete: :cascade
  add_foreign_key "notifications", "tenants", name: "notifications_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "offline_payment_methods", "tenants", name: "offline_payment_methods_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "order_detail_addons", "addon_items", name: "order_detail_addons_addon_item_id_foreign", on_delete: :nullify
  add_foreign_key "order_detail_addons", "order_details", name: "order_detail_addons_order_detail_id_foreign", on_delete: :cascade
  add_foreign_key "order_details", "tenants", name: "order_details_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "order_partial_payments", "tenants", name: "order_partial_payments_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "order_status_logs", "orders", name: "order_status_logs_order_id_foreign", on_delete: :cascade
  add_foreign_key "orders", "admins", column: "subscriber_id", name: "orders_subscriber_id_foreign", on_delete: :nullify
  add_foreign_key "orders", "tenants", name: "orders_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "phone_verifications", "tenants", name: "phone_verifications_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "product_addon_groups", "addon_groups", name: "product_addon_groups_addon_group_id_foreign", on_delete: :cascade
  add_foreign_key "product_addon_groups", "products", name: "product_addon_groups_product_id_foreign", on_delete: :cascade
  add_foreign_key "product_searched_by_user", "users", name: "product_searched_by_user_user_id_foreign", on_delete: :cascade
  add_foreign_key "products", "admins", column: "subscriber_id", name: "products_subscriber_id_foreign", on_delete: :nullify
  add_foreign_key "products", "cadatech_admins", column: "approved_by", name: "products_approved_by_foreign", on_delete: :nullify
  add_foreign_key "reviews", "tenants", name: "reviews_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "searched_keyword_users", "users", name: "searched_keyword_users_user_id_foreign", on_delete: :cascade
  add_foreign_key "stock_reservations", "products", name: "stock_reservations_product_id_foreign", on_delete: :cascade
  add_foreign_key "stock_reservations", "tenants", name: "stock_reservations_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "stores", "tenants", name: "stores_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "subscriptions", "cadatech_admins", column: "changed_by", name: "subscriptions_changed_by_foreign", on_delete: :nullify
  add_foreign_key "subscriptions", "stores", name: "subscriptions_store_id_foreign", on_delete: :cascade
  add_foreign_key "subscriptions", "subscription_plans", name: "subscriptions_subscription_plan_id_foreign", on_delete: :restrict
  add_foreign_key "telescope_entries_tags", "telescope_entries", column: "entry_uuid", primary_key: "uuid", name: "telescope_entries_tags_entry_uuid_foreign", on_delete: :cascade
  add_foreign_key "tenant_api_credentials", "tenants", name: "tenant_api_credentials_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "tenant_api_tokens", "tenant_api_credentials", name: "tenant_api_tokens_tenant_api_credential_id_foreign", on_delete: :cascade
  add_foreign_key "tenant_settings", "subscription_plans", name: "tenant_settings_subscription_plan_id_foreign", on_delete: :nullify
  add_foreign_key "tenant_settings", "tenants", name: "tenant_settings_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "time_slots", "tenants", name: "time_slots_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "users", "tenants", name: "users_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "visited_products", "users", name: "visited_products_user_id_foreign", on_delete: :cascade
  add_foreign_key "wallet_transactions", "tenants", name: "wallet_transactions_tenant_id_foreign", on_delete: :cascade
  add_foreign_key "wishlists", "tenants", name: "wishlists_tenant_id_foreign", on_delete: :cascade
end
