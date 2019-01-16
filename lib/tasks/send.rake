namespace :send do
  desc "Send daily job alert"
  task :send_deily_job => :environment  do
    puts "! Task:Send daily job alert #{Time.now}"
    Resume.where(id:8).each do |resume|
      jobs = Job.includes(:company,:location).search_for_send(value: resume.key, location:resume.location_id)
      puts jobs.count
      if jobs.present?
        puts "отправляем"
        JobsMailer.daily_job_alert(resume.client.email, Job.includes(:company,:location).search_for_send(value: resume.key, location:resume.location_id)).deliver_later
      end
    end
    puts "! Task:Send daily job alert: End #{Time.now}"
  end
end