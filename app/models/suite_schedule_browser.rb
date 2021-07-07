# frozen_string_literal: true

class SuiteScheduleBrowser < ApplicationRecord
  belongs_to :browser
  belongs_to :suite_schedule
end
