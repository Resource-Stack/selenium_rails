class SuiteSchedule < ActiveRecord::Base
    has_one :test_suite

    def self.schedule_daily_suites
        @schedules = SuiteSchedule.where(:active=> true)
        today = Time.now.utc.to_date
        suite_time_hash = Set[]
        @schedules.map do |s|
            start_date = s.start_date.to_date
            end_date = s.end_date.to_date
            if start_date>=today && today<= end_date
                suite_time_hash.add({suite_id: s.test_suite_id, date: s.time.to_time.utc})
            end
        end
        suite_time_hash.to_a.map do |s|
            Scheduler.create_new_schedule(s[:suite_id], s[:date], 1)
        end
    end
end
  