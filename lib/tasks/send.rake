namespace :send do
  desc "Send daily job alert"
  task :send_deily_job => :environment  do
    puts "! Task:Send daily job alert #{Time.now}"
    Resume.find_each do |resume|
      jobs = Job.includes(:company,:location).search_for_send(value: resume.key, location:resume.location_id)
      if jobs.present?
        JobsMailer.daily_job_alert(resume.client.email, jobs).deliver_now
      end
    end
    Clientforalert.find_each do |client|
      jobs = Job.includes(:company,:location).search_for_send(value: client.key, location:client.location_id)
      if jobs.present?
        JobsMailer.daily_job_alert(client.email, jobs).deliver_now
      end
    end
    puts "! Task:Send daily job alert: End #{Time.now}"
  end
end

