# frozen_string_literal: true

json.array!(@test_cases) do |test_case|
  json.extract! test_case, :id, :field_name, :field_type, :read_element, :input_value, :string, :action, :action_url
  json.url test_case_url(test_case, format: :json)
end
