class JobsMailer < ApplicationMailer

  def add_job(job)
    @job = job
    #!!TODO
    mail(to:@job[:mail], subject: "Your Job have published on Jobs Galore!")
  end

  def daily_job_alert(email, list_of_jobs)
    @list_of_jobs = list_of_jobs
    mail(to: email, subject: "Daily Job Alert")
  end
end