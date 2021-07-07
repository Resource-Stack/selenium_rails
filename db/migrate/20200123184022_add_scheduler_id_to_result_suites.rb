# frozen_string_literal: true

class AddSchedulerIdToResultSuites < ActiveRecord::Migration[6.0]
  def change
    add_column :result_suites, :scheduler_id, :integer
  end
end
