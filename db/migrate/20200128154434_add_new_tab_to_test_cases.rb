# frozen_string_literal: true

class AddNewTabToTestCases < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :new_tab, :text
  end
end
