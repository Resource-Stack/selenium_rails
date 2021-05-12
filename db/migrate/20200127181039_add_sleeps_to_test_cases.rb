# frozen_string_literal: true

class AddSleepsToTestCases < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :sleeps, :integer
  end
end
