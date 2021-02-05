class CreateProjectUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_users do |t|
      t.references :project, foreign_key: true
      t.references :user, foreign_key: true
      t.references :project_role, foreign_key: true
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
