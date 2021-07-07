# frozen_string_literal: true

class AddProjectIdToEnvironment < ActiveRecord::Migration[6.0]
  def change
    add_reference :environments, :project, foreign_key: true
  end
end
