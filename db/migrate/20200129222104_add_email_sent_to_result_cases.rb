# frozen_string_literal: true

class AddEmailSentToResultCases < ActiveRecord::Migration[6.0]
  def change
    add_column :result_cases, :email_sent, :boolean, default: false
  end
end
