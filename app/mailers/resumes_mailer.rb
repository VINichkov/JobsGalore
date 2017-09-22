class ResumesMailer < ApplicationMailer


  def add_resume(mail)
    mail(to:mail, subject: "Your resume was published on JobsGalore!")
  end
end