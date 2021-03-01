class EnvironmentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  before_action :set_environment, only: [:show, :edit, :update, :destroy]

  def index
    project_id = params[:project_id]
    if project_id.present?
      #TODO: Validate user access to projects
      session[:project_id] = project_id
      @environments = Environment.where.not(:project_id=>nil).where(:project_id=>project_id)
    else
      redirect_to projects_index_path
    end    
  end

  def show
  end

  def new
    @environment = Environment.new
    @environment.project_id = session[:project_id]
  end

  def edit
    @custom = @environment.custom_commands.new
  end

  def create
    @environment = Environment.new(environment_params)
      if @environment.save
        redirect_to environments_path(:project_id=> @environment.project_id)
      else
        respond_to do |format|
        format.html { render :new }
        format.json { render json: @environment.errors, status: :unprocessable_entity }
        end
      end
  end

  def update
    custom_command_params = params[:custom_command]
    if !custom_command_params.present?
      @custom.update(custom_command_params)
    end
   
    if @environment.update(environment_params)
      redirect_to environments_path(:project_id=> @environment.project_id)
    else
      respond_to do |format|
          format.html { render :edit }
          format.json { render json: @environment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @environment.destroy
    redirect_to environments_path(:project_id=> @environment.project_id)
  end
  
  def test_suites
    @environment_id = params[:id]
    @environment_name = Environment.find(@environment_id).name
    @status = params[:status]
    #if params[:status].present?
    #  @status = params[:status] 
    #else
    #  @status = "Draft"
    #end
    if !params[:status].nil?
      @test_suites = TestSuite.where('environment_id = ? AND status = ?', @environment_id, @status)
    else
      @test_suites = TestSuite.where(environment_id: @environment_id)
    end
    respond_to do |format|  
      format.html
    end
  end

  def list_all_reports
    @schedule_cases = Scheduler.find(params[:id])
    @result_suites = ResultSuite.where(:scheduler_id=> @schedule_cases.id).pluck(:id)
    @selected_result_suite = params[:rs_id].to_i
    if (@selected_result_suite.nil? || (!@result_suites.include? (@selected_result_suite)))
      @selected_result_suite = @result_suites[0]
      session[:selected_result_suite] = @selected_result_suite
    end

    @result_cases = ResultCase.where(scheduler_id: params[:id], result_suite_id: @selected_result_suite)
    respond_to do |format|  
      format.html{}
    end
  end

  def download_results
    ids = params[:result_cases]
    @rc_cases = Array.new
    ids.each do |rc|
      @rc_cases << ResultCase.find(rc)
    end
    respond_to do |format|
      format.html
      format.csv do#{ send_data @results.to_csv, filename: "result-#{Date.today}.csv" }
        headers['Content-Disposition'] = "attachment; filename=\"reports-#{Date.today}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def reports_main
    @project_id = session[:project_id]
    @environment_id = session[:environment_id]

    if params[:project_id].present?
      @project_id = params[:project_id] 
      @environment_id = params[:environment_id]
    end

    session[:project_id] = @project_id
    session[:environment_id] = @environment_id

    @projects = ProjectUser.where({:is_active=>true, :user_id=> current_user.id}).joins(:project).select("projects.id, projects.name")
    @environments = @project_id.nil? ? [] : Environment.where(:project_id=>@project_id).select(:id, :name)

    if @project_id.present? && @environment_id.present?
        @sche_status_name = Scheduler.group(:status)
        if params[:start_date].present? && params[:end_date].present?
          @sche_status = Scheduler.where('scheduled_date BETWEEN ? AND ?', params[:start_date], params[:end_date]).group(:status).count
        else 
          @sche_status = Scheduler.group(:status).count
        end
        @suite_status = TestSuite.group(:status).count
        @schedule = Array.new
        @test_suites = TestSuite.where(environment_id: @environment_id).pluck(:id)
        if @test_suites.present?
          @test_suites.each do |ts_id|
            sch = Scheduler.where(test_suite_id: ts_id)
            if params[:start_date].present? && params[:end_date].present?
              sch = sch.where('scheduled_date BETWEEN ? AND ?', params[:start_date], params[:end_date])
            end

            if !params[:status].nil?
              sch = sch.where(status: params[:status])
            end
            sch_id = sch.pluck(:id)

            if !sch_id.blank?
              sch_id.each do |id|
                @schedule << Scheduler.find(id)
              end
            end
        end
        end
      end 
    end

  def reports
    redirect_to reports_main_path
  end

  def filter_reports
    @sche_status_name = Scheduler.group(:status)
    if params[:start_date].present? && params[:end_date].present?
      @sche_status = Scheduler.where('scheduled_date BETWEEN ? AND ?', params[:start_date], params[:end_date]).group(:status).count
    else 
      @sche_status = Scheduler.group(:status).count
    end
    @suite_status = TestSuite.group(:status).count
    if session[:enviro_id].present?
      id = session[:enviro_id]
    else
      id = current_user.default_environ
    end
    @e = Environment.find(id).name
    #@sch = Array.new
    @schedule = Array.new
    @test_suites = TestSuite.where(environment_id: id).pluck(:id)
    if @test_suites.present?
      @test_suites.each do |ts_id|
        if !params[:status].nil?
          sch_id = Scheduler.where(test_suite_id: ts_id, status: params[:status]).pluck(:id)
        else
          sch_id = Scheduler.where(test_suite_id: ts_id).pluck(:id)
        end
        if !sch_id.blank?
          sch_id.each do |id|
          
          @schedule << Scheduler.find(id)
        end
        end
      
    end
    end
    respond_to do |format|
     format.js
   end

  end
  
  def run_suites
    if params[:suite].present?
      params[:suite].each do |s|
        suite = TestSuite.find(s[0])
        schedule = Scheduler.new
        schedule.test_suite_id = s[0]
        schedule.scheduled_date = DateTime.now
        schedule.status = "READY"
        schedule.save!
        if params[:commit] == "Schedule Now"
          system "/home/newprod/SeleniumWebTester/start.sh"
        end
        # RUNSUITELOGIC put logic for running each test suite here.
      end
    else
      return redirect_to "/environments/#{session[:enviro_id]}/test_suites"
    end
    return redirect_to "/environments/#{session[:enviro_id]}/test_suites"
  end

  def images
    @file_name = params[:file_name]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_environment
      @environment = Environment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def environment_params
      params.require(:environment).permit(:name, :url, :username, :password, :login_field, :password_field, :action_button,:default_suite_id, :user_emails, :git_url, :git_username, :project_id, :git_password, :git_branch, :selenium_tester_url, :login_required, test_suite_ids: [])
    end
end
