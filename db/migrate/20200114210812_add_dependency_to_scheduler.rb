# frozen_string_literal: true

class AddDependencyToScheduler < ActiveRecord::Migration[5.0]
  def change
    add_column :schedulers, :dependency, :boolean, default: false
  end
end
