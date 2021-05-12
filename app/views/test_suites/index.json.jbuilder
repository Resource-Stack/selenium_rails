# frozen_string_literal: true

json.array!(@test_suites) do |test_suite|
  json.extract! test_suite, :id, :name
  json.url test_suite_url(test_suite, format: :json)
end
