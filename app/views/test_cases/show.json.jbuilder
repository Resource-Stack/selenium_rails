# frozen_string_literal: true

json.extract! @test_case, :id, :field_name, :field_type, :read_element, :input_value, :string, :action, :action_url,
              :created_at, :updated_at
