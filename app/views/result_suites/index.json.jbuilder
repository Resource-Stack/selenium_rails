# frozen_string_literal: true

json.array!(@result_suites) do |result_suite|
  json.extract! result_suite, :id, :rd_id, :test_suite_id, :start_time, :end_time
  json.url result_suite_url(result_suite, format: :json)
end
