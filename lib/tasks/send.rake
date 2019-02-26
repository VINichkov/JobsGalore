namespace :send do

  #(a.close - Time.now.to_date).to_i
  #
  desc "Send daily job alert"
  task :send_deily_job => :environment  do
    puts "! Task:Send daily job alert #{Time.now}"
    Resume.find_each do |resume|
      begin
        jobs = Job.includes(:company,:location).search_for_send(value: resume.key, location:resume.location_id)
        if jobs.present? and jobs.count ==10
          JobsMailer.daily_job_alert(resume.client.email, jobs).deliver_now
        end
      rescue
        puts "Error:resume.id =#{resume.id} :#{$!} "
      end

    end
    Clientforalert.find_each do |client|
      begin
        jobs = Job.includes(:company,:location).search_for_send(value: Search.str_to_search(client.key.delete("<>{}#@!,:*&()'`\"’|")), location:client.location_id)
        if jobs.present? and jobs.count ==10
          JobsMailer.daily_job_alert(client.email, jobs).deliver_now
        end
      rescue
        puts "Error:client.email =#{client.email} :#{$!} "
      end
    end
    puts "! Task:Send daily job alert: End #{Time.now}"
  end
end

