# frozen_string_literal: true

json.array!(@results_dictionaries) do |results_dictionary|
  json.extract! results_dictionary, :id, :description
  json.url results_dictionary_url(results_dictionary, format: :json)
end
