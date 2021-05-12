# frozen_string_literal: true

class AddEnvironmentIdToTestSuites < ActiveRecord::Migration[6.0]
  def change
    add_column :test_suites, :environment_id, :integer
  end
end
