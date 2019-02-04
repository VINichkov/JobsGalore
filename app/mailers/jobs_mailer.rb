class JobsMailer < ApplicationMailer

  def add_job(job)
    @utm = {:utm_source=>:email, :utm_medium=>:email, :utm_campaign=>:add_job}.to_query
    @job = job
    mail(to:@job[:mail], subject: "New opportunity was just posted on Jobs Galore!")
  end

  def daily_job_alert(email, list_of_jobs)
    @utm = "?"+{:utm_source=>:email, :utm_medium=>:email, :utm_campaign=>:resume_alert}.to_query
    @list_of_jobs = list_of_jobs
    mail(to: email, subject: "Daily Job Alert")
  end
end