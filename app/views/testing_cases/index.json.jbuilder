# frozen_string_literal: true

json.array!(@testing_cases) do |testing_case|
  json.extract! testing_case, :id, :field_name, :field_type, :business_rules
  json.url testing_case_url(testing_case, format: :json)
end
