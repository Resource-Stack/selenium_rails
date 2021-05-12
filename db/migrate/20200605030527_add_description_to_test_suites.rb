# frozen_string_literal: true

class AddDescriptionToTestSuites < ActiveRecord::Migration[6.0]
  def change
    add_column :test_suites, :description, :string
  end
end
