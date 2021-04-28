class ResultsDictionary < ApplicationRecord
  has_many :result_suites
  has_many :result_cases
end
