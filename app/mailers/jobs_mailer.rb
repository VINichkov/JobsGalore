class JobsMailer < ApplicationMailer


  def add_job(mail)
    mail(to:mail, subject: "Your vacancy was published on JobsGalore!")
  end
end