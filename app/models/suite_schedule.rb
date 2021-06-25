# frozen_string_literal: true

class SuiteSchedule < ActiveRecord::Base
  has_one :test_suite
  has_many :scheduler
  has_many :suite_schedule_browser

  def self.schedule_daily_suites
    today = Time.now.utc.to_date

    @schedules =  SuiteSchedule.where(active:true).where("start_date>=?",today).where("?<=end_date",today).select(:id, :start_date, :end_date, :test_suite_id, :time).as_json
  
byebug
    @schedules.map do |s|
      browser_ids = SuiteScheduleBrowser.where(:suite_schedule_id=>s["id"]).pluck(:browser_id)
      if browser_ids.empty? 
        Scheduler.create_new_schedule(s[:suite_id], s[:date], 1, Browser.browsers[:chrome])
      else
        browser_ids.map do |b|
          Scheduler.create_new_schedule(s[:suite_id], s[:date], 1, b)
        end
      end
    end
  end
end
