class CaseSuite < ApplicationRecord
  belongs_to :test_cases
  belongs_to :test_suites
end
