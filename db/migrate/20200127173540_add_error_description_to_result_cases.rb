# frozen_string_literal: true

class AddErrorDescriptionToResultCases < ActiveRecord::Migration[6.0]
  def change
    add_column :result_cases, :error_description, :text
  end
end
