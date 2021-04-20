class Project < ApplicationRecord
     has_many :project_user
     has_many :environment
     belongs_to :user
     after_create :create_manager

     def create_manager
          ProjectUser.create_new_user(self.id, self.user_id, ProjectRole.roles[:Manager])
     end

     def self.create_new_project(name, user_id)
          @project = Project.create({:name=>name, :user_id=>user_id, :is_active=>true})
          return @project
     end

     def self.deactivate_project(project_id)
          @project = Project.find(project_id)
          if !@project.nil?
               @project.is_active = false
               @project.project_user.update_all(:is_active=>false)
               @project.save!
          end
     end
end
