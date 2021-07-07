# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.boolean :is_active, default: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
