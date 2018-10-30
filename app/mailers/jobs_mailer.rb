class JobsMailer < ApplicationMailer

  def add_job(job)
    @job = job
    #!!TODO
    mail(to:@job[:mail], subject: "Your Job have published on Jobs Galore!")
  end
end