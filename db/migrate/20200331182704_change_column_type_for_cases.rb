# frozen_string_literal: true

class ChangeColumnTypeForCases < ActiveRecord::Migration[6.0]
  def change
    change_column :test_cases, :new_tab, :boolean, default: false
    change_column :test_cases, :need_screenshot, :boolean, default: false
  end
end
