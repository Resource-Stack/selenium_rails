class AddIndexToResultSuite < ActiveRecord::Migration[6.0]
  def change
    add_column :result_suites, :scheduler_index, :integer, :default => -1
  end  
end
