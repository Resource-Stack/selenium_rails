# frozen_string_literal: true

json.array!(@environments) do |environment|
  json.extract! environment, :id, :url, :username, :password
  json.url environment_url(environment, format: :json)
end
