class JobsMailer < ApplicationMailer


  def add_job(job)
    @job = job
    mail(to:@job[:mail], subject: "Your vacancy was published on JobsGalore!")
  end
end