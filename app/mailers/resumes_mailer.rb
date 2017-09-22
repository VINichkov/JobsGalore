class ResumesMailer < ApplicationMailer


  def add_resume(resume)
    @resume = resume
    mail(to:@resume.client.email, subject: "Your resume was published on JobsGalore!")
  end
end