# frozen_string_literal: true

class AddSeleniumTesterUrlToEnvironments < ActiveRecord::Migration[6.0]
  def change
    add_column :environments, :selenium_tester_url, :text
  end
end
