# frozen_string_literal: true

class AddUserIdToResultSuites < ActiveRecord::Migration[6.0]
  def change
    add_column :result_suites, :user_id, :integer
  end
end
