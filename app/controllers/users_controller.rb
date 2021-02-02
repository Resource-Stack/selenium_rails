class UsersController < ApplicationController
  def index
  	@user = current_user
    @all_users = User.all
  	@environ_list = Environment.all.pluck(:name, :id)
  end

  def update
  	@user= current_user
  	@user.default_environ = params[:default_environ]
  	@user.save!

  	redirect_to users_index_path
  end
  
  private

  	def user_params
  		params.require(:users).permit(:id, :email, :terms_acknowledged, :invite_start_date, :privacy_acknowledged, :default_environ)
  	end
end
