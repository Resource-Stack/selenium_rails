# frozen_string_literal: true

class AddCommandIdToTestCase < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :custom_command_id, :integer, default: 0
  end
end
