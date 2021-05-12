# frozen_string_literal: true

class AddNameToEnvironments < ActiveRecord::Migration[6.0]
  def change
    add_column :environments, :name, :string
  end
end
