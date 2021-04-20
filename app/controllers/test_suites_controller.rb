class TestSuitesController < ApplicationController
  include FormatConcern
  before_action :set_test_suite, only: [:show, :edit, :update, :destroy]

  def test_suite_main
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
      if !params[:status].blank? 
          @test_suites = TestSuite.where(environment_id: @environment_id, status: params[:status])
        else
          @test_suites = TestSuite.where(environment_id: @environment_id)
      end  
    end
  end

  def index
    redirect_to test_suite_main_path
  end

  def show
    @ts = TestSuite.find(params[:id])
      respond_to do |format|
      format.html
      format.js
      end
  end

  def new
    @test_suite = TestSuite.new
  end

  def edit
    @test_cases = @test_suite.test_cases
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @test_suite = TestSuite.new(test_suite_params)

    respond_to do |format|
      if @test_suite.save
        format.html { redirect_to @test_suite, notice: 'Test suite was successfully created.' }
        format.json { render :show, status: :created, location: @test_suite }
      else
        format.html { render :new }
        format.json { render json: @test_suite.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    env = Environment.find(@test_suite.environment_id)

    respond_to do |format|
      if @test_suite.update(test_suite_params)
        format.html { redirect_to test_suites_path, notice: 'Test suite was successfully updated.' }
        format.json { render :index, status: :ok, location: @test_suite }
      else
        format.html { render :edit }
        format.json { render json: @test_suite.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    id = params[:id]
    test_suite = TestSuite.find(id)
    if test_suite.test_cases.present?
      tc_ids = test_suite.test_cases.pluck(:id)
      tc_ids.each do |id|
        rc = ResultCase.where(test_case_id: id)
        rc.destroy_all
        tc = TestCase.where(id: id)
        tc.destroy_all
      end
      test_suite.test_cases.destroy
    end
    if test_suite.schedulers.present?
      sch_ids = test_suite.schedulers.pluck(:id)
      sch_ids.each do |s_id|
        rs = ResultSuite.where(scheduler_id: s_id)
        rs.destroy_all
        sch = Scheduler.where(id: s_id)
        sch.destroy_all
      end
      #test_suite.schedulers.destroy
    end
    @test_suite.destroy #This will destroy caseSuites also
    respond_to do |format|
      format.html { redirect_to "/test_suites", notice: 'Test suite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def test_cases
    @test_suite = TestSuite.find(params[:id])
    @test_cases = @test_suite.test_cases.order('id DESC')
    @chartData = {
      suiteID: @test_suite.id,
      case_detail: @test_cases.select(:id, :description).reverse.as_json,
      flowState: @test_suite.flow_state
    }
  end

  def update_suite_flow
    begin
      flow_state = params[:flow_state]
      suite_id = params[:suite_id]
      case_data = params[:case_data]

      @test_suite = TestSuite.find(suite_id)
      @test_suite.flow_state = flow_state.to_json
      @test_suite.save!
      case_ids = case_data.pluck(:test_case_id)

      @caseSuites = CaseSuite.where(:test_case_id=> case_ids, :test_suite_id => suite_id)

      @caseSuites.each do |suite|
        @case_suite =case_data.to_a.find { |cd| cd[:test_case_id] == suite.test_case_id}.as_json
        rejected_case_id_array = @case_suite["rejectedCaseIds"]
        accepted_case_id_array = @case_suite["acceptedCaseIds"]

        suite.rejected_case_ids = rejected_case_id_array.as_json
        suite.accepted_case_ids = accepted_case_id_array.as_json
        suite.save!
      end

      render json: format_response_json({
                  message: 'Updated the flow!',
                  status: true
              })
    rescue => exception
      render json: format_response_json({
                  message: 'Failed to update the flow!',
                  status: false
              })
    end

  end

  
  def import_suite
    
  end
  
  def import
    if params[:dependency].present?
      dependency = params[:dependency]
    else
      dependency = 0
    end
    TestSuite.import(params[:file], params[:name], session[:environment_id], params[:description], dependency)
  end
  
  def tests_ran
    @test_suite = TestSuite.find(params[:id])
    @schedulers = @test_suite.schedulers
  end

  def unschedule 
    id = params[:id]
    #environ_id = id = session[:enviro_id]
    #@test_suites = TestSuite.where(environment_id: environ_id)
    s = Scheduler.where(test_suite_id: id)
    s.each do |st|
      if st.status == "READY"
        st.destroy
      end
    end
    respond_to do |format|
        format.html {redirect_to "/test_suites/"}
    end
    #render :template => "environments/test_suites.html.erb"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_suite
      @test_suite = TestSuite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_suite_params
      params.require(:test_suite).permit(:name, :environment_id, :description, :status, :dependency, test_case_ids: [])
    end
end
