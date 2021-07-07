# frozen_string_literal: true

environments = Environment.all

environments.each do |e|
  # repo_url = e.git_url
  git_folder_name = e.git_url.sub('.git', '').split('/')[-1]
  test_suite_ids = e.test_suites.pluck(:id)
  url = e.git_url.split('//')
  git_url = "#{url[0]}//#{u}:#{p}@#{url[1]}"
  b_url = e.git_url.split('@')
  bit_url = "#{b_url[0]}:#{p}@#{b_url[1]}"
  if e.staging_folder.nil?
    e.staging_folder = "/mnt/c/Users/susmi/selenium_rails/public/repos/#{e.name}/#{git_folder_name}"
    Dir.chdir('/mnt/c/Users/susmi/selenium_rails/public') # added this line because mkdir on public is giving permission errors so I'm changin directory first and then creating a folder there
    Dir.mkdir("repos/#{e.name}")
    Dir.chdir("/mnt/c/Users/susmi/selenium_rails/public/repos/#{e.name}")

    if repo_url.include? 'github'
      system "git clone #{git_url}"

    elsif repo_url.include? 'bitbucket'
      system "git clone #{bit_url}"
    end

  elsif repo_url.include? 'github'
    system "sh shell.SH #{git_url}"
    file = File.open('output.txt')
    status = file.read
    if status = 'up to date'
      e.git_status = 'success'
    else
      test_suite_ids.each do |_ids|
        sch = Scheduler.where(test_suite_id: i)
        sch.each do |s|
          s.status = 'READY'
        end
      end
    end

  elsif repo_url.include? 'bitbucket'
    system "git pull #{bit_url}"
    file = File.open('output.txt')
    status = file.read
    if status = 'up to date'
      e.git_status = 'success'
    else
      test_suite_ids.each do |_ids|
        sch = Scheduler.where(test_suite_id: i)
        sch.each do |s|
          s.status = 'READY'
          s.save
        end
      end
    end
  end
  e.save
  # system "git clone #{e.git_url}"
  # hotline repo is cloned and is under public/development/hotline
end
