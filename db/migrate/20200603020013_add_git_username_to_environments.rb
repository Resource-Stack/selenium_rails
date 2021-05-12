# frozen_string_literal: true

class AddGitUsernameToEnvironments < ActiveRecord::Migration[6.0]
  def change
    add_column :environments, :git_username, :string
  end
end
