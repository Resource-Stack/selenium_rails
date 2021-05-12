# frozen_string_literal: true

class AddPriorityToTestCase < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :priority, :integer
  end
end
