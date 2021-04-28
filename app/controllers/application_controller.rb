class ApplicationController < ActionController::Base
  include FormatConcern
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :one_agent_init_before_action
  after_action :one_agent_complete_after_action
  around_action :one_agent_ensure_execution_between_action

  def web_application_info_handle
    return OneAgentSdk.onesdk_webapplicationinfo_create("testing.resourcestack.com", "SeleniumApplication", "/selenium_rails")
  end

  def path
    return request.url
  end

  def tracer
    OneAgentSdk.onesdk_incomingwebrequesttracer_create(web_application_info_handle, path, request.method)
  end

  def one_agent_init_before_action
    # Initialize controller actions before execution
    puts "------------ BEFORE ACTION -----------------"

    remote_address = request.remote_ip
    request_headers = []

    request.headers.each { |key, value|
      request_headers.push([key.to_s, value.to_s])
    }

    OneAgentSdk.onesdk_incomingwebrequesttracer_set_remote_address(tracer, remote_address)
    request_headers.each do |header|
      OneAgentSdk.onesdk_incomingwebrequesttracer_add_request_header(tracer, header[0], header[1])
    end

    OneAgentSdk.onesdk_tracer_start(tracer)
  end

  def one_agent_ensure_execution_between_action
    begin
      yield
    rescue => err
      # Surround with try-catch and log during execution
      puts "------------ BETWEEN ACTION -----------------"
      OneAgentSdk.onesdk_tracer_error(tracer, err.class.name, err.message)
      raise err
    end
  end

  def one_agent_complete_after_action
    # Report after execution
    puts "------------ AFTER ACTION -----------------"

    response.headers.each { |key, value|
      OneAgentSdk.onesdk_incomingwebrequesttracer_add_response_header(tracer, key.to_s, value.to_s)
    }
    OneAgentSdk.onesdk_incomingwebrequesttracer_set_status_code(tracer, response.status)

    OneAgentSdk.onesdk_tracer_end(tracer)
    OneAgentSdk.onesdk_webapplicationinfo_delete(web_application_info_handle)
  end

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
