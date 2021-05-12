# frozen_string_literal: true

class AddFlowCompleteCaseIdToCaseSuite < ActiveRecord::Migration[6.0]
  def change
    add_column :case_suites, :accepted_case_ids, :string, default: '[]'
    add_column :case_suites, :rejected_case_ids, :string, default: '[]'
  end
end
