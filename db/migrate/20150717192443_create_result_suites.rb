# frozen_string_literal: true

class CreateResultSuites < ActiveRecord::Migration[6.0]
  def change
    create_table :result_suites do |t|
      t.integer :rd_id
      t.integer :test_suite_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
