# frozen_string_literal: true

class Browser < ApplicationRecord
  enum browser: %i[chrome firefox safari edge]
  has_many :suite_schedule_browsers
  has_many :scheduler
end
