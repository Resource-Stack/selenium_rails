# frozen_string_literal: true

json.array!(@test_data) do |test_datum|
  json.extract! test_datum, :id, :test_id, :result_id, :date_of_test, :browser, :details
  json.url test_datum_url(test_datum, format: :json)
end
