class WelcomeController < ApplicationController
  def home
    @environments = Environment.all
    if params[:commit] == "Go"
      logger.debug "HELP ME"
      session[:enviro_id] = params[:environment][:id]
      #redirect_to :controller => "environments", :action => "test_suites", :id => params[:environment][:id]
      redirect_to :controller => "test_suites", :action => "index", :environ_id => params[:environment][:id]
    end
  end
  private

  def welcome_params
  	params.require(:environment).permit(:url, :username, :name, :login_field, :result_name, :action_button, :result_value, :default_suite_id)
  end
end