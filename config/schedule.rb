# frozen_string_literal: true
require File.expand_path(File.dirname(__FILE__) + "/environment")

set :output, "#{Rails.root}/log/cron_log.log"

set :environment, "development"
job_type :runner, "rvm use 2.6.3 && cd :path && bundle exec rails runner -e :environment ':task' :output"

every 1.day, at: '00:00 am' do
        puts "Schdeuling"
  runner 'SuiteSchedule.schedule_daily_suites'
end

every 1.day, at: '4:30 am' do
  runner 'Environment.create_repos'
end

