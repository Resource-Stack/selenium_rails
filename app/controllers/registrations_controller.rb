# frozen_string_literal: true

class RegistrationseController < ApplicationController
  require 'recaptcha'
  before_action :verify_recaptcha, only: [:create]
  def verify_recaptcha
    response = Recaptcha.verify(params)
    session[:sign_up] = params[:user].except(:password, :password_confirmation, :remoteip)
    if response.code == 200
      if response[‘success’]
        flash[:notice] = 'Recaptcha verification successful.'
      else
        redirect_to new_user_registration_path(user: params[:user]),
                    alert: 'Recaptcha verification error.'
      end
    else
      redirect_to new_user_registration_path(user: params[:user]),
                  alert: 'HTTP connection error.'
    end
  end
end
