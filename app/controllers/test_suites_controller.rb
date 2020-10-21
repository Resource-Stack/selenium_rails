class TestSuitesController < ApplicationController
  before_action :set_test_suite, only: [:show, :edit, :update, :destroy]

  # GET /test_suites
  # GET /test_suites.json
  def index
    environ_id = session[:enviro_id] 
    @environment_name = Environment.find(environ_id).name
    if !params[:status].blank? 
      logger.debug("INSIDE IF TESTSUITES")
      @test_suites = TestSuite.where(environment_id: environ_id, status: params[:status])
    else
      @test_suites = TestSuite.where(environment_id: environ_id)
    end  
    logger.debug("#{@test_suites.count}")
  end

  # GET /test_suites/1
  # GET /test_suites/1.json
  def show
    @ts = TestSuite.find(params[:id])
    logger.debug("INSIDE TS SHOW ACTION")
      respond_to do |format|
      format.html
      format.js
      end
  end

  # GET /test_suites/new
  def new
    @test_suite = TestSuite.new
  end

  # GET /test_suites/1/edit
  def edit
    @test_cases = @test_suite.test_cases
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /test_suites
  # POST /test_suites.json
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

  # PATCH/PUT /test_suites/1
  # PATCH/PUT /test_suites/1.json
  def update
    env = Environment.find(@test_suite.environment_id)
    #logger.debug "deeeefault #{params[:default]} default_suite_id #{env.default_suite_id != @test_suite.id} params is 1? #{params[:default] == '1'}"
    #if (params[:default] == "1") && (env.default_suite_id != @test_suite.id)
    #  logger.debug "Getting here"
    #  env.update(default_suite_id: @test_suite.id)
    #end
    #if !params[:case].nil?
    #  params[:case].each do |c|
    #    logger.debug "#{c[0]}"
    #    CaseSuite.create(test_suite_id: @test_suite.id, test_case_id: c[0])
    #  end
      
    #end
    logger.debug("TEST SUITE #{test_suite_params.inspect}")

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

  # DELETE /test_suites/1
  # DELETE /test_suites/1.json
  def destroy
    id = params[:id]
    test_suite = TestSuite.find(id)
    if test_suite.test_cases.present?
      logger.debug("TEST CASES ARE #{test_suite.test_cases.inspect}")
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
      logger.debug("SCHEDULERS ARE  #{test_suite.schedulers.inspect}")
      #test_suite.schedulers.destroy
    end
    @test_suite.destroy #This will destroy caseSuites also
    respond_to do |format|
      format.html { redirect_to "/environments/#{session[:enviro_id]}/test_suites", notice: 'Test suite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def test_cases
    @test_suite = TestSuite.find(params[:id])
    @test_cases = @test_suite.test_cases.order('priority DESC')
  end

  
  def import_suite
    
  end
  
  def import
    logger.debug("THE PARAMS ARE #{params.inspect}")
    if params[:dependency].present?
      logger.debug("DEPENDENCY PRESENT")
      dependency = params[:dependency]
    else
      dependency = 0
    end
    TestSuite.import(params[:file], params[:name], session[:enviro_id], params[:description], dependency)
  end
  
  def tests_ran
    @test_suite = TestSuite.find(params[:id])
    @schedulers = @test_suite.schedulers
  end

  def unschedule 
    logger.debug("THE PARAMS IN UNSCHEDULE ARE")
    id = params[:id]
    logger.debug("THE ID is #{id.inspect}")
    #environ_id = id = session[:enviro_id]
    #@test_suites = TestSuite.where(environment_id: environ_id)
    s = Scheduler.where(test_suite_id: id)
    logger.debug("THE Scheduler is #{s.inspect}")
    s.each do |st|
      if st.status == "READY"
        logger.debug("GOING INTO READY")
        st.destroy
        respond_to do |format|
          format.html {redirect_to "/environments/#{session[:enviro_id]}/test_suites"}
        end
      end
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
