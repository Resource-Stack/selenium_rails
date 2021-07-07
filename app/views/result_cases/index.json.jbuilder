# frozen_string_literal: true

json.array!(@result_cases) do |result_case|
  json.extract! result_case, :id, :rd_id, :test_case_id, :result_suite_id
  json.url result_case_url(result_case, format: :json)
end
