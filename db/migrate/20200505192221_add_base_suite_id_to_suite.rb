# frozen_string_literal: true

class AddBaseSuiteIdToSuite < ActiveRecord::Migration[6.0]
  def change
    add_column :test_suites, :base_suite_id, :integer, default: nil
  end
end
