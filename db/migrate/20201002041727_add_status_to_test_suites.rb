class AddStatusToTestSuites < ActiveRecord::Migration[6.0]
  def change
    add_column :test_suites, :status, :string
  end
end
