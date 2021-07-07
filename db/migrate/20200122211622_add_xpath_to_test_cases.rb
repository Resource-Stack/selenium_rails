# frozen_string_literal: true

class AddXpathToTestCases < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :xpath, :text
  end
end
