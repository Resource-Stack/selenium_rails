# frozen_string_literal: true

class AddDependencyToTestCase < ActiveRecord::Migration[5.0]
  def change
    add_column :test_cases, :dependency, :boolean, default: false
  end
end
