# frozen_string_literal: true

class Scheduler < ActiveRecord::Base
  belongs_to :test_suite
  belongs_to :suite_schedule
  belongs_to :browser
  has_many :result_suites

  after_create :schedule_created

  def schedule_created
    status = test_suite.status
    if !status.nil? && status.downcase == 'final'
      tester_path = test_suite.environment.selenium_tester_url
      unless tester_path.nil?
        scheduler_id = id
        mode = 'headless'
        file_directory = File.dirname(tester_path)
        if Dir.exist?(file_directory)
          Dir.chdir(file_directory) do
            Process.fork { system("#{tester_path} #{mode} #{scheduler_id}") }
          end
        end
      end
    end
  end

  def self.create_new_schedule(suite_id, date, number_of_times, browser_id)
    schedule = Scheduler.new
    schedule.test_suite_id = suite_id
    schedule.scheduled_date = date
    schedule.number_of_times = number_of_times
    schedule.browser_id = browser_id
    schedule.status = 'READY'
    schedule.save!
  end
end
