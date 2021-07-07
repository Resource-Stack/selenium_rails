# frozen_string_literal: true

class ResultSuite < ActiveRecord::Base
  belongs_to :results_dictionary, foreign_key: :rd_id
  belongs_to :test_suite, foreign_key: :test_suite_id
  has_many :result_cases
  belongs_to :scheduler
end
