class TestCasesController < ApplicationController
  before_action :set_test_case, only: [:show, :edit, :update, :destroy]

  # GET /test_cases
  # GET /test_cases.json
  def index
    logger.debug("SESSION OBJECT #{session[:enviro_id].inspect}")
    id = session[:enviro_id]
    @e = Environment.find(id).name
    @tc = TestSuite.where(environment_id: id)
    @t = TestSuite.where(environment_id: id).pluck(:id)
    logger.debug("TEST SUITE #{@t.inspect}")
    if @t.present?
      @test_cases = Array.new
      @t.each do |t_id|
        tc_ids = TestSuite.find(t_id).test_cases.pluck(:id)
        logger.debug("TEST CASES #{tc_ids.inspect}")
        if tc_ids.present?
          tc_ids.each do |id|
          #@ids = tc_ids.pluck(:id) 
          #logger.debug("TEST SUITES IDS #{@ids}")
          #@test_cases = TestCase.find(@ids)
            @test_cases << TestCase.find(id)
            logger.debug("TEST SUITES ARE #{@test_cases.count}")
          end
      end
      end
    else
      
    end
  end

  # GET /test_cases/1
  # GET /test_cases/1.json
  def show
  end

  # GET /test_cases/new
  def new
    @test_case = TestCase.new
  end

  # GET /test_cases/1/edit
  def edit
  end

  # POST /test_cases
  # POST /test_cases.json
  def create
    @test_case = TestCase.new(test_case_params)

    respond_to do |format|
      if @test_case.save
        format.html { redirect_to @test_case, notice: 'Test case was successfully created.' }
        format.json { render :show, status: :created, location: @test_case }
      else
        format.html { render :new }
        format.json { render json: @test_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_cases/1
  # PATCH/PUT /test_cases/1.json
  def update
    respond_to do |format|
      if @test_case.update(test_case_params)
        format.html { redirect_to @test_case, notice: 'Test case was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_case }
      else
        format.html { render :edit }
        format.json { render json: @test_case.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_show
    @test_case = TestCase.all
    respond_to do |format|
      format.html
      format.js
    end 
  end

  def export_results
    #@results = TestSuite.find(params[:id]).test_cases
    @results = TestSuite.all
    respond_to do |format|
      format.html
      format.csv do#{ send_data @results.to_csv, filename: "result-#{Date.today}.csv" }
        headers['Content-Disposition'] = "attachment; filename=\"#{Date.today}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
      #format.xlsx #{render xlsx: 'export_results'}
    end
    #render xlsx: "test_cases/export_results.xlsx.axlsx"
  end

  def export
    Rails.logger.debug("PARRAAAAAAAAAAAAAAAMSSSSSSSSSSSS #{params.inspect}")
    @results = TestSuite.find(params[:test_suite_ids]).test_cases.joins(:case_suites).select("test_cases.*", "case_suites.sequence").order("case_suites.sequence ASC")
    respond_to do |format|
      format.html
      format.csv { send_data prep_csv(@results), filename: "test_suite_#{TestSuite.find(params[:test_suite_ids]).name.sub(" ", "")}_#{Time.now.strftime("%m/%d/%Y_%I:%M%p")}.csv"}
    end
  end

  # DELETE /test_cases/1
  # DELETE /test_cases/1.json
  def destroy
    @test_case.destroy
    respond_to do |format|
      format.html { redirect_to test_cases_url, notice: 'Test case was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # method to add custom columns in CSV
    def prep_csv(results)
      wanted_columns = ["field_name","xpath","field_type","read_element","input_value","action","action_url","sleeps","description","new_tab","base_url","sequence"]
      CSV.generate do |csv|
        csv << wanted_columns
        results.each do |result|
          csv << result.attributes.values_at(*wanted_columns)
        end
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_test_case
      @test_case = TestCase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_case_params
      params.require(:test_case).permit(:field_name, :field_type, :read_element, :base_url, :input_value, :string, :action, :action_url, :base_url, :dependency, :login, :sleeps, :new_tab, :description, :need_screenshot, :xpath, :sort, :enter_action, test_suite_ids: [])
    end
end
