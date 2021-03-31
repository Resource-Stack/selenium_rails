class ProjectsController < ApplicationController
    include FormatConcern
    def index
        @user_projects = ProjectUser.where(:user_id => current_user.id, :is_active=>true).joins(:project).where(projects:{:is_active=>true}).joins(:user).select("projects.id, projects.name, projects.user_id as owner_id, projects.created_at, users.email as owner").as_json
        #render "index.html.erb"
    end

    def create_project
        if params[:projectName].present?
            Project.create_new_project(params[:projectName], current_user.id)
            redirect_to projects_index_path
        else
            render js: "alert('Project name missing!')"
        end
    end

    def delete_project
        Project.deactivate_project(params[:project_id])
        redirect_to projects_index_path
    end

    def get_environments_for_filter
        @project_id = params[:project_id]
        @environments = @project_id.present? ? Environment.where(:project_id=> @project_id).select(:id, :name).as_json : []
        render json: format_response_json({
            status: true,
            result: @environments
        })
    end
end