# frozen_string_literal: true

class ResultCasesController < ApplicationController
  before_action :set_result_case, only: %i[show edit update destroy]

  def index
    @result_cases = ResultCase.all
  end

  def show; end

  def new
    @result_case = ResultCase.new
  end

  def edit; end

  def create
    # I know there will be multiple schedulers, but for testing i'm implementing for single scheduler.
    test_suite_id = Scheduler.find(result_case_params[:scheduler_id]).test_suite_id
    environment_id = TestSuite.find(test_suite_id).environment_id
    @user_emails = Environment.find(environment_id).user_emails.split(',')
    @result_case = ResultCase.new(result_case_params)

    respond_to do |format|
      if @result_case.save
        # UserMailer.with(user: @user).send_email.deliver_later
        @user_emails.each do |user|
          UserMailer.send_email(user).deliver_now
        end
        format.html { redirect_to @result_case, notice: 'Result case was successfully created.' }
        format.json { render :show, status: :created, location: @result_case }
      else
        format.html { render :new }
        format.json { render json: @result_case.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @result_case.update(result_case_params)
        format.html { redirect_to @result_case, notice: 'Result case was successfully updated.' }
        format.json { render :show, status: :ok, location: @result_case }
      else
        format.html { render :edit }
        format.json { render json: @result_case.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result_case.destroy
    respond_to do |format|
      format.html { redirect_to result_cases_url, notice: 'Result case was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_result_case
    @result_case = ResultCase.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def result_case_params
    params.require(:result_case).permit(:rd_id, :test_case_id, :result_suite_id, :screenshot_file_location,
                                        :scheduler_id, :error_description, :email_sent)
  end
end
