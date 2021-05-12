# frozen_string_literal: true

class AddStagingFolderToEnvironments < ActiveRecord::Migration[6.0]
  def change
    add_column :environments, :staging_folder, :string
  end
end
