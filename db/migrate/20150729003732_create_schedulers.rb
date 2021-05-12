# frozen_string_literal: true

class CreateSchedulers < ActiveRecord::Migration[6.0]
  def change
    create_table :schedulers do |t|
      t.integer :test_suite_id
      t.timestamp :scheduled_date
      t.timestamp :completed_date
      t.string :status

      t.timestamps
    end
  end
end
