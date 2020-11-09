class EnvironmentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  before_action :set_environment, only: [:show, :edit, :update, :destroy]

  # GET /environments
  # GET /environments.json
  def index
    @environments = Environment.all
  end

  # GET /environments/1
  # GET /environments/1.json
  def show
  end

  # GET /environments/new
  def new
    @environment = Environment.new
  end

  # GET /environments/1/edit
  def edit
    @custom = @environment.custom_commands.new
  end

  # POST /environments
  # POST /environments.json
  def create
    @environment = Environment.new(environment_params)
    

    respond_to do |format|
      if @environment.save
        format.html { redirect_to @environment, notice: 'Environment was successfully created.' }
        format.json { render :show, status: :created, location: @environment }
      else
        format.html { render :new }
        format.json { render json: @environment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /environments/1
  # PATCH/PUT /environments/1.json
  def update
    custom_command_params = params[:custom_command]
    logger.debug("PARAMS OF CUSTOM COMMAND #{custom_command_params.inspect}")
    if !custom_command_params.present?
      @custom.update(custom_command_params)
      logger.debug("IN THE ENV UPDATE CUSTOM COMMAND #{@custom.inspect}")
    end
    respond_to do |format|
      if @environment.update(environment_params)
        format.html { redirect_to @environment, notice: 'Environment was successfully updated.' }
        format.json { render :show, status: :ok, location: @environment }
      else
        format.html { render :edit }
        format.json { render json: @environment.errors, status: :unprocessable_entity }
      end

    end
  end

  # DELETE /environments/1
  # DELETE /environments/1.json
  def destroy
    @environment.destroy
    respond_to do |format|
      format.html { redirect_to environments_url, notice: 'Environment was successfully destroyed.' }
      format.json { head :no_content }
    end
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
      logger.debug("STATUS AND ENVIRONMENT")
      
      @test_suites = TestSuite.where('environment_id = ? AND status = ?', @environment_id, @status)
      logger.debug("TEST SUITE #{@test_suites.inspect}")
    else
      @test_suites = TestSuite.where(environment_id: @environment_id)
      logger.debug("TEST SUITE in ELSE #{@test_suites.inspect}")
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
    logger.debug("PARAMS FROM DOWNLOAD #{params.inspect}")
    ids = params[:result_cases]
    @rc_cases = Array.new
    ids.each do |rc|
      @rc_cases << ResultCase.find(rc)
    end
    logger.debug("RC IN RESULTS ENVIRO #{@rc_cases.inspect}")
    respond_to do |format|
      format.html
      format.csv do#{ send_data @results.to_csv, filename: "result-#{Date.today}.csv" }
        headers['Content-Disposition'] = "attachment; filename=\"reports-#{Date.today}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
      #format.xlsx #{render xlsx: 'export_results'}
    end
  end

  def reports
    if params[:start_date].present? && params[:end_date].present?
      @sche_status = Scheduler.where('scheduled_date BETWEEN ? AND ?', params[:start_date], params[:end_date]).group(:status).count
      logger.debug("INSIDE IF #{@sche_status.inspect}")
    else 
      @sche_status = Scheduler.group(:status).count
      logger.debug("INSIDE ELSE #{@sche_status.inspect}")
    end
    @suite_status = TestSuite.group(:status).count
    logger.debug("SESSION OBJECT #{session[:enviro_id].inspect}")
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
      logger.debug(" TEST SUITE #{@test_suites} ")
      @test_suites.each do |ts_id|
        sch_id = Scheduler.where(test_suite_id: ts_id).pluck(:id)
        if !sch_id.blank?
          #@sch << sch_id
        
        logger.debug("SCHEDULERS #{sch_id}")
      
        sch_id.each do |id|
          
          @schedule << Scheduler.find(id)
          logger.debug(" TEST SUITE #{@schedule.inspect}")
        end
        end
      
    end
    end
  end
  
  def run_suites
    logger.debug "COMMIT #{params[:commit]}"
    if params[:suite].present?
      params[:suite].each do |s|
        logger.debug "CHECK CHECK SUITE SUITE #{s}"
        suite = TestSuite.find(s[0])
        schedule = Scheduler.new
        schedule.test_suite_id = s[0]
        schedule.scheduled_date = DateTime.now
        schedule.status = "READY"
        schedule.save!
        logger.debug "#{suite.id} #{suite.name}"
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
      params.require(:environment).permit(:name, :url, :username, :password, :login_field, :password_field, :action_button,:default_suite_id, :user_emails, :git_url, :git_username, :git_password, :git_branch, :selenium_tester_url, :login_required, test_suite_ids: [])
    end
end
