class JobsMailer < ApplicationMailer

  def add_job(job)
    @job = job
    #!!TODO
    mail(to:@job[:mail], subject: "Your vacancy was published on JobsGalore!")
  end
end