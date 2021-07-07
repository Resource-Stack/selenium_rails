# frozen_string_literal: true

class AddGitPasswordToEnvironments < ActiveRecord::Migration[6.0]
  def change
    add_column :environments, :git_password, :string
  end
end
