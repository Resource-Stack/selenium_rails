# frozen_string_literal: true

class AddGitUrlToEnvironments < ActiveRecord::Migration[6.0]
  def change
    add_column :environments, :git_url, :text
  end
end
