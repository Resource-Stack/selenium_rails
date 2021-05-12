# frozen_string_literal: true

class AddBaseUrlToTestSuites < ActiveRecord::Migration[6.0]
  def change
    add_column :test_suites, :base_url, :text
  end
end
