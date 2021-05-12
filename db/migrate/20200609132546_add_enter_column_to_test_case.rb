# frozen_string_literal: true

class AddEnterColumnToTestCase < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :enter_action, :boolean, default: false
  end
end
