# frozen_string_literal: true

class AddGitBranchToEnvironments < ActiveRecord::Migration[6.0]
  def change
    add_column :environments, :git_branch, :string
  end
end
