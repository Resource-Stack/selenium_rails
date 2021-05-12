# frozen_string_literal: true

class AddDescriptionToTestCases < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :description, :text
  end
end
