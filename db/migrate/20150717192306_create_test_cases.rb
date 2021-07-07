# frozen_string_literal: true

class CreateTestCases < ActiveRecord::Migration[6.0]
  def change
    create_table :test_cases do |t|
      t.string :field_name
      t.string :field_type
      t.string :read_element
      t.string :input_value
      t.string :string
      t.string :action
      t.text :action_url

      t.timestamps
    end
  end
end
