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

ActiveRecord::Schema.define(version: 202012111533081) do

  create_table "browsers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "browsers_id"
    t.index ["browsers_id"], name: "index_browsers_on_browsers_id"
  end

  create_table "case_suites", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "test_case_id"
    t.integer "test_suite_id"
    t.integer "sequence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "accepted_case_ids", default: "[]"
    t.string "rejected_case_ids", default: "[]"
  end

  create_table "custom_commands", charset: "utf8mb3", force: :cascade do |t|
    t.integer "environment_id"
    t.string "name"
    t.text "command"
    t.json "parameters"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "environments", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.text "url"
    t.string "username"
    t.string "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "login_field"
    t.string "password_field"
    t.string "action_button"
    t.string "result_name"
    t.string "result_value"
    t.integer "default_suite_id"
    t.text "user_emails"
    t.text "selenium_tester_url"
    t.text "git_url"
    t.string "git_username"
    t.string "git_password"
    t.string "git_branch"
    t.string "staging_folder"
    t.string "git_status"
    t.boolean "login_required", default: true
    t.bigint "project_id"
    t.index ["project_id"], name: "index_environments_on_project_id"
  end

  create_table "project_roles", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "project_users", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "project_id"
    t.integer "user_id"
    t.bigint "project_role_id"
    t.boolean "is_active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["project_role_id"], name: "index_project_users_on_project_role_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: true
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "result_cases", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "rd_id"
    t.integer "test_case_id"
    t.integer "result_suite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "screenshot_file_location"
    t.integer "scheduler_id"
    t.text "error_description"
    t.boolean "email_sent", default: false
  end

  create_table "result_suites", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "rd_id"
    t.integer "test_suite_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.integer "scheduler_id"
    t.integer "scheduler_index", default: -1
  end

  create_table "results_dictionaries", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedulers", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "test_suite_id"
    t.timestamp "scheduled_date"
    t.timestamp "completed_date"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "dependency", default: false
    t.integer "number_of_times", default: 1
    t.bigint "suite_schedule_id"
    t.bigint "browser_id"
    t.index ["browser_id"], name: "index_schedulers_on_browser_id"
    t.index ["suite_schedule_id"], name: "index_schedulers_on_suite_schedule_id"
  end

  create_table "suite_schedule_browsers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "browser_id"
    t.bigint "suite_schedule_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["browser_id"], name: "index_suite_schedule_browsers_on_browser_id"
    t.index ["suite_schedule_id"], name: "index_suite_schedule_browsers_on_suite_schedule_id"
  end

  create_table "suite_schedules", charset: "utf8mb3", force: :cascade do |t|
    t.integer "test_suite_id"
    t.string "name"
    t.boolean "active", default: true
    t.timestamp "start_date"
    t.timestamp "end_date"
    t.string "time"
    t.bigint "suite_schedules_id"
    t.index ["suite_schedules_id"], name: "index_suite_schedules_on_suite_schedules_id"
  end

  create_table "test_cases", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "field_name"
    t.string "field_type"
    t.string "read_element"
    t.string "input_value"
    t.string "string"
    t.string "action"
    t.text "action_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "dependency", default: false
    t.text "base_url"
    t.text "xpath"
    t.integer "sleeps"
    t.boolean "new_tab", default: false
    t.text "description"
    t.boolean "need_screenshot", default: false
    t.integer "custom_command_id", default: 0
    t.boolean "enter_action", default: false
    t.integer "priority"
    t.boolean "javascript_conditional_enabled", default: false
    t.text "javascript_conditional"
  end

  create_table "test_suites", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "environment_id"
    t.boolean "dependency", default: false
    t.text "base_url"
    t.integer "base_suite_id"
    t.string "description"
    t.string "status"
    t.text "flow_state"
  end

  create_table "users", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "terms_acknowledged", default: false
    t.boolean "privacy_acknowledged", default: false
    t.integer "default_environ"
    t.boolean "admin"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "invite_start_date"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "environments", "projects"
  add_foreign_key "project_users", "project_roles"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "schedulers", "browsers"
  add_foreign_key "schedulers", "suite_schedules"
  add_foreign_key "suite_schedule_browsers", "browsers"
  add_foreign_key "suite_schedule_browsers", "suite_schedules"
end
