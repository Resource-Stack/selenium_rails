# frozen_string_literal: true

class WelcomeController < ApplicationController
  def home
    redirect_to projects_index_path
  end

  private

  def welcome_params
    params.require(:environment).permit(:url, :username, :name, :login_field, :result_name, :action_button,
                                        :result_value, :default_suite_id)
  end
end
