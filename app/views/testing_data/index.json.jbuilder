# frozen_string_literal: true

json.array!(@testing_data) do |testing_datum|
  json.extract! testing_datum, :id, :test_id, :result_id, :date_of_test, :browser, :details
  json.url testing_datum_url(testing_datum, format: :json)
end
