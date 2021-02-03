# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 202012111533081) do

  create_table "case_suites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "test_case_id"
    t.integer "test_suite_id"
    t.integer "sequence"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "accepted_case_ids", default: "[]"
    t.string "rejected_case_ids", default: "[]"
  end

  create_table "custom_commands", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "environment_id"
    t.string "name"
    t.text "command"
    t.json "parameters"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "environments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "url"
    t.string "username"
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
  end

  create_table "result_cases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "rd_id"
    t.integer "test_case_id"
    t.integer "result_suite_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "screenshot_file_location"
    t.integer "scheduler_id"
    t.text "error_description"
    t.boolean "email_sent", default: false
  end

  create_table "result_suites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "rd_id"
    t.integer "test_suite_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.integer "scheduler_id"
    t.integer "scheduler_index", default: -1
  end

  create_table "results_dictionaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schedulers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "test_suite_id"
    t.timestamp "scheduled_date"
    t.timestamp "completed_date"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "dependency", default: false
    t.integer "number_of_times", default: 1
  end

  create_table "suite_schedules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "test_suite_id"
    t.string "name"
    t.boolean "active", default: true
    t.timestamp "start_date"
    t.timestamp "end_date"
    t.string "time"
  end

  create_table "test_cases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "field_name"
    t.string "field_type"
    t.string "read_element"
    t.string "input_value"
    t.string "string"
    t.string "action"
    t.text "action_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.string "javascript_conditional"
  end

  create_table "test_suites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "environment_id"
    t.boolean "dependency", default: false
    t.text "base_url"
    t.integer "base_suite_id"
    t.string "description"
    t.string "status"
    t.text "flow_state"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "terms_acknowledged", default: false
    t.boolean "privacy_acknowledged", default: false
    t.integer "default_environ"
    t.boolean "admin", default: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
