class BrowserExtensionController < ApplicationController
  include FormatConcern
  protect_from_forgery with: :null_session
  before_action :authenticate_user_token
  skip_before_action :authenticate_user_token, only: [:login_user, :logout_user]

  def authenticate_user_token
    #CHECK IF TOKEN IS VALID DATEWISE, ROLEWISE, AND SET CURRENT USER
    token_info = User.decode_jwt_token(request.headers["Authorization"])
    cur_user = nil
    if token_info != nil # Token is valid
        valid_session = token_expired?(token_info)
        cur_user = {'user_id': token_info[:user_id],'valid_session': valid_session}
    end

    if cur_user.nil? || !cur_user[:valid_session]
      response.headers["Logout"] = "true";
      message = cur_user.nil? ? "You are unauthorized from making this request!": "You have been logged out. Please login again." 
      render json: format_response_json({
        message: message,
        status: false
      }), status: 401
    end
  end

  def token_expired?(token_info)
    Time.now.to_i <= token_info[:exp]
  end
  
  def login_user
    begin
      byebug
      @params =params[:data]
      user_name = @params["email-address"]
      password = @params[:password]
      user = User.where(email: user_name).first
      valid_password = user.valid_password?(password)

      if(!valid_password)
        render json: format_response_json({
          message: 'Invalid username or password!',
          status: false,
        })
      else 
        token = User.generate_jwt_token(user.id);
        render json: format_response_json({
          message: 'Successfully logged in!',
          status: true,
          result: {
            "accessToken": token
          }
        })
      end
    rescue
      render json: format_response_json({
        message: 'Failed to login!',
        status: false
      })
    end
  end
  
  def logout_user
    begin
      # jwt token can't be invalidated
      render json: format_response_json({
        message: 'Successfully logged out!',
        status: true,
        result: true
      })
    rescue
      render json: format_response_json({
        message: 'Failed to log user out!',
        status: false
      })
    end
  end
  
  def get_environments
    begin
      @environments = Environment.select(:id,:name).as_json
      render json: format_response_json({
        message: 'Environments retrieved!',
        status: true,
        result: @environments
      })
    rescue
      render json: format_response_json({
        message: 'Failed to retrieve environments!',
        status: false
      })
    end
  end

  def get_custom_commands
    begin
      environment_id = params[:environment_id]
      @custom_commands = CustomCommand.where(environment_id: environment_id).select(:id, :name, :parameters).as_json
      render json: format_response_json({
        message: 'Custom commands retrieved!',
        status: true,
        result: @custom_commands
      })
    rescue
      render json: format_response_json({
        message: 'Failed to retrieve custom commands!',
        status: false
      })
    end
  end
  
  def create_test_suite
    begin
      @params = params[:data]
      @suite = TestSuite.new
      @suite.environment_id = @params[:environment_id]
      @suite.name = @params[:suite_name]
      @suite.base_suite_id= @params[:base_suite_id]
      if(@suite.save)
        render json: format_response_json({
          message: 'Test suite created!',
          status: true
        })
      else
        render json: format_response_json({
          message: 'Failed to create new case suite!',
          status: false
        })
      end
    rescue
      render json: format_response_json({
        message: 'Failed to create new case suite!',
        status: false
      })
    end
  end
  
  def get_test_suites
    begin
      environment_id = params[:environment_id]
      @suites = TestSuite.where(environment_id: environment_id).select(:id,:name).as_json
      
      render json: format_response_json({
        message: 'Test suites retrieved!',
        status: true,
        result: @suites
      })
    rescue
      render json: format_response_json({
        message: 'Failed to retrieve case suites!',
        status: false
      })
    end
  end
  
  def create_test_case
    begin
      @params = params[:data]
      suite_id = @params[:suite_id]
      @test_case = TestCase.new(test_case_params(@params[:test_case].except(:case_id)))
      record_saved = false
      if @test_case.save
        @total_suites = CaseSuite.where(test_suite_id: suite_id).count
        @case_suite = CaseSuite.new 
        @case_suite.test_suite_id= suite_id
        @case_suite.sequence = @total_suites + 1
        @case_suite.test_case_id= @test_case.id
        record_saved = @case_suite.save
      end

      if record_saved
        render json: format_response_json({
          message: 'Test case created!',
          status: true
        })
      else
        render json: format_response_json({
          message: 'Failed to create test case!',
          status: false
        })
      end
    rescue
      render json: format_response_json({
        message: 'Failed to create new test case!',
        status: false
      })
    end
  end
  
  def update_test_case
    begin
      @test_case = params[:data][:test_case]
      @test_case["id"] = @test_case[:case_id]
      @case_id = @test_case[:id]
      @success = TestCase.find(@case_id).update_attributes(test_case_params(@test_case))

      if(@success)
        render json: format_response_json({
          message: 'Test case updated!',
          status: true
        })
      else        
        render json: format_response_json({
          message: 'Failed to update case detail!',
          status: false
        })
      end
    rescue
      render json: format_response_json({
        message: 'Failed to update case detail!',
        status: false
      })
    end
  end
  
  def get_test_cases
    begin
      suite_id = params[:suite_id]
      case_ids = CaseSuite.where(test_suite_id: suite_id).pluck(:test_case_id)
      
      @test_cases = TestCase.where("id IN (?)", case_ids).select("id, description as name, custom_command_id").as_json
      
      render json: format_response_json({
        message: 'Test cases retrieved!',
        status: true,
        result: @test_cases
      })
    rescue
      render json: format_response_json({
        message: 'Failed to retrieve case suites!',
        status: false
      })
    end
  end
  
  def get_case_detail 
    begin
      case_id = params[:case_id]
      
      @detail = TestCase.where(id: case_id).select(:id,:field_name,:field_type,:description,:xpath,:read_element,:input_value,:action,:action_url,:sleeps,:need_screenshot,:new_tab, :enter_action).first.as_json
      @detail["case_id"] = case_id

      render json: format_response_json({
        message: 'Case detail retrieved!',
        status: true,
        result: @detail
      })
    rescue
      render json: format_response_json({
        message: 'Failed to retrieve case detail!',
        status: false
      })
    end
  end

  private 
  def test_case_params(test_case)
      test_case.permit([:id,:field_name,:field_type,:description,:xpath,:read_element,:input_value,:action,:action_url,:sleeps,:need_screenshot,:new_tab,:custom_command_id,:enter_action])
  end

  def case_suite_params
    params.require(:case_suite).permit([:test_case_id, :test_suite_id ])
  end

  def test_suite_params
    params.require(:test_suite).permit([:name, :environment_id, :base_suite_id ])
  end
end