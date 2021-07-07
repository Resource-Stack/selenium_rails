# frozen_string_literal: true

class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :project_role

  def self.create_new_user(project_id, user_id, role_id)
    already_exists = ProjectUser.where(is_active: true, user_id: user_id, project_id: project_id).count.positive?
    unless already_exists
      @project_user = ProjectUser.create({ project_id: project_id, user_id: user_id,
                                           project_role_id: role_id, is_active: true })
      @project_user
    end
  end

  def self.update_user_role(id, role_id)
    @project_user = ProjectUser.find(id)
    unless @project_user.nil?
      @project_user.project_role_id = role_id
      @project_user.save!
    end
    @project_user
  end

  def self.delete_project_user(id)
    @project_user = ProjectUser.find(id)
    unless @project_user.nil?
      @project_user.is_active = false
      @project_user.save!
    end
  end
end
