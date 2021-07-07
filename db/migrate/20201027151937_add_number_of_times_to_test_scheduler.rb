# frozen_string_literal: true

class AddNumberOfTimesToTestScheduler < ActiveRecord::Migration[6.0]
  def change
    add_column :schedulers, :number_of_times, :integer, default: 1
  end
end
