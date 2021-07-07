# frozen_string_literal: true

class CreateSuiteScheduleBrowsers < ActiveRecord::Migration[6.1]
  def change
    create_table :suite_schedule_browsers do |t|
      t.references :browser, foreign_key: true
      t.references :suite_schedule, foreign_key: true
      t.timestamps
    end
  end
end
