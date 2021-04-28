class ResultCase < ApplicationRecord
  belongs_to :results_dictionary, foreign_key: :rd_id
  belongs_to :test_case, foreign_key: :test_case_id
  belongs_to :result_suite, foreign_key: :result_suite_id
end
