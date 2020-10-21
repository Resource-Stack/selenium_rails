class Scheduler < ActiveRecord::Base
  belongs_to :test_suite

  after_create :schedule_created

  def schedule_created
    status = self.test_suite.status
    if !status.nil? && status.downcase=='final'
       tester_path = self.test_suite.environment.selenium_tester_url
       if !tester_path.nil?
          scheduler_id = self.id
          mode = "headless"
            file_directory = File.dirname(tester_path)
            Dir.chdir(file_directory){
                      system("#{tester_path} #{mode} #{scheduler_id}")
            }
       end
    end
  end

  def self.create_new_schedule(suite_id, date)
    schedule = Scheduler.new
    schedule.test_suite_id = suite_id
    schedule.scheduled_date = date
    schedule.status = "READY"
    schedule.save!
  end
end
