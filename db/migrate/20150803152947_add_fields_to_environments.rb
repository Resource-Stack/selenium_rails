# frozen_string_literal: true

class AddFieldsToEnvironments < ActiveRecord::Migration[6.0]
  def change
    add_column :environments, :login_field, :string
    add_column :environments, :password_field, :string
    add_column :environments, :action_button, :string
    add_column :environments, :result_name, :string
    add_column :environments, :result_value, :string
  end
end
