# frozen_string_literal: true

class CreateResultCases < ActiveRecord::Migration[6.0]
  def change
    create_table :result_cases do |t|
      t.integer :rd_id
      t.integer :test_case_id
      t.integer :result_suite_id

      t.timestamps
    end
  end
end
