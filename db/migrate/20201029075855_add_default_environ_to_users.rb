# frozen_string_literal: true

class AddDefaultEnvironToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :default_environ, :integer
  end
end
