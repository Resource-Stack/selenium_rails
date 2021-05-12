# frozen_string_literal: true

class UpdateSchedulerToSupportBrowser < ActiveRecord::Migration[6.1]
  def change
    add_reference :scheduler, :suite_schedules, foreign_key: true, null: true
    add_reference :scheduler, :browsers, foreign_key: true
  end
end
