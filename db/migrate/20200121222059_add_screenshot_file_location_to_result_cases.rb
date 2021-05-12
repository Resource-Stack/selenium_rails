# frozen_string_literal: true

class AddScreenshotFileLocationToResultCases < ActiveRecord::Migration[6.0]
  def change
    add_column :result_cases, :screenshot_file_location, :text
  end
end
