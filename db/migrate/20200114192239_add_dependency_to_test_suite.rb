# frozen_string_literal: true

class AddDependencyToTestSuite < ActiveRecord::Migration[5.0]
  def change
    add_column :test_suites, :dependency, :boolean, default: false
  end
end
