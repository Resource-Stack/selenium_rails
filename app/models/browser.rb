# frozen_string_literal: true

class Browser < ApplicationRecord
  enum browser: { chrome: 1, firefox: 2, safari: 3, edge: 4 }
  has_many :suite_schedule_browsers
  has_many :scheduler
end
