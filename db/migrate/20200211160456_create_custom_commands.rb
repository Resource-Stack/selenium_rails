# frozen_string_literal: true

class CreateCustomCommands < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_commands do |t|
      t.integer :environment_id
      t.string :name
      t.text :command
      t.json :parameters

      t.timestamps
    end
  end
end
