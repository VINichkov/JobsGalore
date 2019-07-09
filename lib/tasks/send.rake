namespace :send do

  #(a.close - Time.now.to_date).to_i
  #
  desc "Send daily job alert"
  task :send_deily_job => :environment  do
    puts "! Task:Send daily job alert #{Time.now}"
    Resume.find_each do |resume|
      begin
        jobs = Job.includes(:company,:location).search_for_send(value: resume.key, location:resume.location_id)
        if jobs.present? and jobs.count == 3
          JobsMailer.daily_job_alert(resume.client.email, jobs).deliver_now
        end
      rescue
        puts "Error:resume.id =#{resume.id} :#{$!} "
      end

    end
    Clientforalert.find_each do |client|
      begin
        jobs = Job.includes(:company,:location).search_for_send(value: Search.str_to_search(client.key.delete("<>{}#@!,:*&()'`\"’|")), location:client.location_id)
        if jobs.present? and jobs.count == 3
          JobsMailer.daily_job_alert(client.email, jobs).deliver_now
        end
      rescue
        puts "Error:client.email =#{client.email} :#{$!} "
      end
    end
    puts "! Task:Send daily job alert: End #{Time.now}"
  end

  desc "Send invitation to post resume"
  task :send_invate_to_post_resume => :environment do
    puts "! Task:Send invitation to post resume #{Time.now}"
    client_for_sending = Clientforalert.all.map do |t|
      client = Client.find_by_email(t.email)
      if client.present?
        t.destroy
        nil
      else
        t.email
      end
    end
    client_for_sending += Client.where(send_email: true, character: TypeOfClient::APPLICANT).map do |t|
      t.email if t.resume.count == 0
    end
    client_for_sending.compact.uniq.each do |email|
      ClientMailer.send_invite_for_posting_resume(email).deliver_now
    end
    puts "! Task:Send invitation to post resume: End #{Time.now}"
  end
end

