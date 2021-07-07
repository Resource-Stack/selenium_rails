# frozen_string_literal: true

class AddSchedulerIdToResultCases < ActiveRecord::Migration[6.0]
  def change
    add_column :result_cases, :scheduler_id, :integer
  end
end
