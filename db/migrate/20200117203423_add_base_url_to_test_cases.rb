# frozen_string_literal: true

class AddBaseUrlToTestCases < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :base_url, :text
  end
end
