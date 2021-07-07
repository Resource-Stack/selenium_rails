# frozen_string_literal: true

class AddNeedScreenshotToTestCases < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :need_screenshot, :text
  end
end
