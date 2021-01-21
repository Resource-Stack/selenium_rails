class AddFlowStateToTestSuite < ActiveRecord::Migration[6.0]
  def change
     add_column :test_suites, :flow_state, :text, :default => nil
  end
end
