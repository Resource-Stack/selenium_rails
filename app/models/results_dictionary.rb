# frozen_string_literal: true

class ResultsDictionary < ActiveRecord::Base
  has_many :result_suites
  has_many :result_cases
end
