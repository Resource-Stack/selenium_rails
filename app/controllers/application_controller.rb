class ApplicationController < ActionController::Base
  include FormatConcern
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def render_result(status = false, message = "", result = nil, status_code = 200)
    render json: format_response_json(
             {
               message: message,
               status: status,
               result: result,
             }
           ),
           :status => status_code
  end

  def after_sign_in_path_for(resource)
    "/home"
  end
end
