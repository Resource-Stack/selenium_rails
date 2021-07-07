# frozen_string_literal: true

class AddSuiteScheduleTable < ActiveRecord::Migration[6.0]
  def change
    create_table :suite_schedules do |t|
      t.integer :test_suite_id
      t.string :name
      t.boolean :active, default: true
      t.timestamp :start_date
      t.timestamp :end_date
      t.string :time
    end
  end
end
