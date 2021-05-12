# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @user = current_user
  end

  def update
    @user = current_user
    @user.default_environ = params[:default_environ]
    @user.save!

    redirect_to users_index_path
  end

  def invite_user
    if current_user.admin?
      @user = User.invite!({ email: params[:userEmail] }, current_user)
      redirect_to users_index_path
    end
  end

  def remove_invitation
    if current_user.admin? && params[:user_id].present?
      @user_to_delete = User.find(params[:user_id])
      @user_to_delete&.destroy
      redirect_to users_index_path
    end
  end

  def resend_invitation
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      unless @user.nil?
        @user.invite!(current_user)
        render js: "alert('Invitation resent!')"
      end
    end
  end

  private

  def user_params
    params.require(:users).permit(:id, :email, :terms_acknowledged, :invite_start_date, :privacy_acknowledged,
                                  :default_environ)
  end
end
