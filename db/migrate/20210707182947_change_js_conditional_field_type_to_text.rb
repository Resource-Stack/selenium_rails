class ChangeJsConditionalFieldTypeToText < ActiveRecord::Migration[6.1]
  def change
    change_column :test_cases, :javascript_conditional, :text, default: nil
  end
end
