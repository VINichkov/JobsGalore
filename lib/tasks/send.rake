namespace :send do

  #(a.close - Time.now.to_date).to_i
  #
  desc "Send daily job alert"
  task :send_deily_job => :environment  do
    puts "! Task:Send daily job alert #{Time.now}"
    DeleteNotUniqClient.new.call

    Resume.find_each do |resume|
      begin
        if resume.client.send_email
          JobsMailer.daily_job_alert(
              email:resume.client.email,
              keys: resume.key,
              location_id:resume.location_id,
              unsubscribe: nil)
              .deliver_now
        end
      rescue
        puts "Error:resume.id =#{resume.id} :#{$!} "
      end
    end

    Clientforalert.find_each do |client|
      begin
        JobsMailer.daily_job_alert(
            email: client.email,
            keys: Search.str_to_search(client.key.delete("<>{}#@!,:*&()'`\"’|")),
            location_id:client.location_id,
            unsubscribe: client.id)
            .deliver_now
      rescue
        puts "Error:client.email =#{client.email} :#{$!} "
      end
    end
    puts "! Task:Send daily job alert: End #{Time.now}"


  end

  task :test => :environment do
    t = Time.now
    Resume.find_each do |resume|
      puts resume.key
    end

    Clientforalert.find_each do |client|
      puts client.key
    end
    puts "! Task:Send daily job alert: End #{(t- Time.now) * 1000} ms"
  end

  desc "Send invitation to post resume"
  task :send_invate_to_post_resume => :environment do
    puts "! Task:Send invitation to post resume #{Time.now}"
    ClientsForInvate.new.call.each do |email|
      ClientMailer.send_invite_for_posting_resume(email).deliver_later
    end
    puts "! Task:Send invitation to post resume: End #{Time.now}"
  end

end

