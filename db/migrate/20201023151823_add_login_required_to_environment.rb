class AddLoginRequiredToEnvironment < ActiveRecord::Migration[6.0]
  def change
      add_column :environments, :login_required, :boolean, :default => true
  end
end
