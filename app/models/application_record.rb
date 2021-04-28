class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def tracer
    byebug

    stmt = ""
    dbinfo_handle = OneAgentSdk.onesdk_databaseinfo_create(
      "selenium_rails",
      OneAgentSdk::ONESDK_DATABASE_VENDOR_MYSQL,
      OneAgentSdk::ONESDK_CHANNEL_TYPE_TCP_IP,
      "localhost"
    )
    return OneAgentSdk.onesdk_databaserequesttracer_create_sql(dbinfo_handle, stmt)
  end

  # before_create :one_agent_before_query
  # after_create :one_agent_after_query
  # around_create :one_agent_between_query

  # before_update :one_agent_before_query
  # after_update :one_agent_after_query
  # around_update :one_agent_between_query

  # before_destroy :one_agent_before_query
  # after_destroy :one_agent_after_query
  # around_destroy :one_agent_between_query

  def one_agent_before_query
    OneAgentSdk.onesdk_tracer_start(tracer)
  end

  def one_agent_between_query
    begin
      yield
    rescue => err
      OneAgentSdk.onesdk_tracer_error(tracer, err.class.name, err.message)
      raise err
    end
  end

  def one_agent_after_query
    # OneAgentSdk.onesdk_databaserequesttracer_set_returned_row_count(tracer, 42 * Random.rand(10))
    # OneAgentSdk.onesdk_databaserequesttracer_set_round_trip_count(tracer, 3)
    OneAgentSdk.onesdk_tracer_end(tracer)
  end
end
