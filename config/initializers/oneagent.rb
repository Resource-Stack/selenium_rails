module RsOneAgent
  def self.init
    require_relative "oneagentsdk"

    logging_callback = proc do |msg|
      puts "### OneAgent SDK Logging Callback: <#{msg}>"
    end

    stub_version = OneAgentSdk::Onesdk_stub_version_t.new
    OneAgentSdk.onesdk_stub_get_version(stub_version)

    puts "stub_version: #{stub_version[:major]}.#{stub_version[:minor]}.#{stub_version[:patch]}"

    puts "Initializing OneAgentSdk"

    ret_init = OneAgentSdk.onesdk_initialize
    print "> onesdk_initialize returned #{ret_init}"
    puts " --> ONESDK_SUCCESS" if ret_init == OneAgentSdk::ONESDK_SUCCESS
    puts " != ONESDK_SUCCESS!" if ret_init != OneAgentSdk::ONESDK_SUCCESS

    OneAgentSdk.onesdk_agent_set_logging_callback(logging_callback)

    state = OneAgentSdk.onesdk_agent_get_current_state
    puts "> onesdk_agent_get_current_state  = #{state} (#{OneAgentSdk.description_for_state(state)})"
    puts "> onesdk_agent_get_version_string = '#{OneAgentSdk.onesdk_agent_get_version_string}'"

    ret_init
  end

  def self.subscribe_events
    # Subscribe to the controller specific web request events
    ActiveSupport::Notifications.subscribe "process_action.action_controller" do |event|
      @ca = ControllerAgent.new(event)
      @ca.process_event
    end

    # Subscribe to the database events
    ActiveSupport::Notifications.subscribe "sql.active_record" do |event|
      @da = DatabaseAgent.new(event)
      @da.process_event
    end
  end

  class DatabaseAgent
    @event = nil

    def initialize(event)
      @event = event
    end

    def event
      return @event
    end

    def process_event
      #   {
      #   sql: "SELECT \"posts\".* FROM \"posts\" ",
      #   name: "Post Load",
      #   connection: #<ActiveRecord::ConnectionAdapters::SQLite3Adapter:0x00007f9f7a838850>,
      #   binds: [#<ActiveModel::Attribute::WithCastValue:0x00007fe19d15dc00>],
      #   type_casted_binds: [11],
      #   statement_name: nil
      # }
      begin
        dbinfo_handle = OneAgentSdk.onesdk_databaseinfo_create(
          "selenium_rails",
          OneAgentSdk::ONESDK_DATABASE_VENDOR_MYSQL,
          OneAgentSdk::ONESDK_CHANNEL_TYPE_TCP_IP,
          "localhost"
        )
        stmt = event.sql

        tracer = OneAgentSdk.onesdk_databaserequesttracer_create_sql(dbinfo_handle, stmt)

        OneAgentSdk.onesdk_tracer_start(tracer)

        # OneAgentSdk.onesdk_databaserequesttracer_set_returned_row_count(tracer, 42 * Random.rand(10))
        # OneAgentSdk.onesdk_databaserequesttracer_set_round_trip_count(tracer, 3)

        OneAgentSdk.onesdk_tracer_end(tracer)

        OneAgentSdk.onesdk_databaseinfo_delete(dbinfo_handle)
      rescue => exception
      end
    end
  end

  class ControllerAgent
    @event = nil

    def initialize(event)
      @event = event
    end

    def event
      return @event
    end

    def process_event
      #   {
      #   controller: "PostsController",
      #   action: "index",
      #   params: {"action" => "index", "controller" => "posts"},
      #   headers: #<ActionDispatch::Http::Headers:0x0055a67a519b88>,
      #   format: :html,
      #   method: "GET",
      #   path: "/posts",
      #   request: #<ActionDispatch::Request:0x00007ff1cb9bd7b8>,
      #   status: 200,
      #   view_runtime: 46.848,
      #   db_runtime: 0.157
      # }

      begin
        request = event.payload[:request]

        path = request.url
        web_application_info_handle = OneAgentSdk.onesdk_webapplicationinfo_create("testing.resourcestack.com", "SeleniumApplication", "/selenium_rails")

        tracer = OneAgentSdk.onesdk_incomingwebrequesttracer_create(web_application_info_handle, path, request.method)

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

        # Make sure it tracks duration

        OneAgentSdk.onesdk_incomingwebrequesttracer_set_status_code(tracer, event.status)

        OneAgentSdk.onesdk_tracer_end(tracer)
        OneAgentSdk.onesdk_webapplicationinfo_delete(web_application_info_handle)
      rescue => exception
      end
    end
  end
end

RsOneAgent.init

RsOneAgent.subscribe_events
