# frozen_string_literal: true

class CreateTestSuites < ActiveRecord::Migration[6.0]
  def change
    create_table :test_suites do |t|
      t.string :name

      t.timestamps
    end
  end
end
