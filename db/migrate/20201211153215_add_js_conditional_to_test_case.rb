class AddJsConditionalToTestCase < ActiveRecord::Migration[6.0]
  def change
     add_column :test_cases, :javascript_conditional_enabled, :boolean, :default => false
     add_column :test_cases, :javascript_conditional, :string, :default => nil
  end
end
