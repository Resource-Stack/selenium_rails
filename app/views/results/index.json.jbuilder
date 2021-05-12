# frozen_string_literal: true

json.array!(@results) do |result|
  json.extract! result, :id, :description
  json.url result_url(result, format: :json)
end
