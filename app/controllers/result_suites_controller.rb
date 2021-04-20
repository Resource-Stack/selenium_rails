class ResultSuitesController < ApplicationController
  before_action :set_result_suite, only: [:show, :edit, :update, :destroy]

  def index
    @result_suites = ResultSuite.all
  end

  def show
  end

  def new
    @result_suite = ResultSuite.new
  end

  def edit
  end

  def create
    @result_suite = ResultSuite.new(result_suite_params)

    respond_to do |format|
      if @result_suite.save
        format.html { redirect_to @result_suite, notice: 'Result suite was successfully created.' }
        format.json { render :show, status: :created, location: @result_suite }
      else
        format.html { render :new }
        format.json { render json: @result_suite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /result_suites/1
  # PATCH/PUT /result_suites/1.json
  def update
    respond_to do |format|
      if @result_suite.update(result_suite_params)
        format.html { redirect_to @result_suite, notice: 'Result suite was successfully updated.' }
        format.json { render :show, status: :ok, location: @result_suite }
      else
        format.html { render :edit }
        format.json { render json: @result_suite.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result_suite.destroy
    respond_to do |format|
      format.html { redirect_to result_suites_url, notice: 'Result suite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list_all_result_suites
    @result_suites = ResultSuite.where(:scheduler_id=>params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result_suite
      @result_suite = ResultSuite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_suite_params
      params.require(:result_suite).permit(:rd_id, :test_suite_id, :start_time, :end_time)
    end
end
