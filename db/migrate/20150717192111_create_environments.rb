# frozen_string_literal: true

class CreateEnvironments < ActiveRecord::Migration[6.0]
  def change
    create_table :environments do |t|
      t.text :url
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
