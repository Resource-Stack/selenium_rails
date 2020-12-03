class UsersController < ApplicationController
  def index
  	logger.debug("Inside user C	@@@@@@@@@@@@@@@@@@@@")
  	@user = current_user
    @all_users = User.all
  	@environ_list = Environment.all.pluck(:name, :id)
  end

  def update
  	logger.debug("IS IT COMING HERE")
  	@user= current_user
  	@user.default_environ = params[:default_environ]
  	@user.save!

  	#render :json => {status: :updated}
  	redirect_to users_index_path
  end

  def invite_to_project
    logger.debug "INVITED BY #{params.inspect}"
    @user = User.invite!(email: params[:email])
    redirect_to users_index_path
  end

  private

  	def user_params
  		params.require(:users).permit(:id, :email, :terms_acknowledged, :invite_start_date, :privacy_acknowledged, :default_environ)
  	end
end
