class CreateProjectRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :project_roles do |t|
      t.string :name
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
