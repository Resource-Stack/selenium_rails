# frozen_string_literal: true

class CreateResultsDictionaries < ActiveRecord::Migration[6.0]
  def change
    create_table :results_dictionaries do |t|
      t.text :description

      t.timestamps
    end
  end
end
