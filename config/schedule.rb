# frozen_string_literal: true

every 1.day, at: '00:01 am' do
  runner 'SuiteSchedule.schedule_daily_suites'
end

every 1.day, at: '4:30 am' do
  runner 'Environment.create_repos'
end
