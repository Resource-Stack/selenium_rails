class ProjectUsersController < ApplicationController
    #GET, EDIT, CREATE, DELETE
    def index
       project_id = params[:project_id]
        if project_id.present?
            session[:project_id] = project_id
            @project_id = project_id
            @project_users = ProjectUser.where(:is_active=>true, :project_id=>@project_id).joins(:user, :project_role, :project).select("project_users.id, projects.user_id as owner_id, project_users.created_at, users.email, project_roles.name as role").as_json
        else
            redirect_to projects_index_path
        end 
       
    end

    def create_project_user_script
        @project_user_id = params[:project_user_id]
        
        @project_id = params[:project_id]
        @user_id = nil
        @role_id = ProjectRole.roles[:Tester]
        @title = "Assign User"
        if @project_user_id.present?
            @project_user = ProjectUser.find(@project_user_id)
            if !@project_user.nil?
                @title = "Edit User" 
                @project_id = @project_user.project_id
                @user_id = @project_user.user_id
                @role_id = @project_user.project_role_id
            end
        end

        @roles = ProjectRole.where(:is_active=>true).select(:id, :name)
        @users = User.where.not(id: current_user.id, invitation_accepted_at: nil).select(:id, :email)

        render partial: 'create_project_user_script.js.erb', layout: false
    end

    def create_project_user
        project_id = params[:project_id]
        user_id = params[:user_id].to_i
        role_id = params[:project_role_id].to_i
        if project_id.present?
            ProjectUser.create_new_user(project_id, user_id, role_id)
            redirect_to project_users_index_path(:project_id=> project_id)
        else
            render js: "alert('Invalid parameters!')"
        end
    end

    def update_project_user
        project_user_id = params[:project_user_id]
        role_id = params[:project_role_id]
        project_id = params[:project_id]
        if project_id.present?
            ProjectUser.update_user_role(project_user_id, role_id)
            redirect_to project_users_index_path(:project_id=> project_id)
        else
            render js: "alert('Invalid parameters!')"
        end
    end

    def delete_project_user
        ProjectUser.delete_project_user(params[:project_user_id])
        redirect_to project_users_index_path(:project_id=> session[:project_id])
    end
end