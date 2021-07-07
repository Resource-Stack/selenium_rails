# frozen_string_literal: true

class CreateBrowsers < ActiveRecord::Migration[6.1]
  def change
    create_table :browsers do |t|
      t.string :name
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
