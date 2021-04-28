logging_callback = proc do |msg|
  puts "### OneAgent SDK Logging Callback: <#{msg}>"
end

def init_oneagent_sdk(logging_callback)
  require_relative "oneagentsdk"

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

ret_init = init_oneagent_sdk(logging_callback)
