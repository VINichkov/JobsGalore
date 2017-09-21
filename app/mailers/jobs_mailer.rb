class JobsMailer < ApplicationMailer
  default from: "#{PropertsHelper::COMPANY} <#{PropertsHelper::EMAIL}>"

  def add_job(mail)
    mail(to:mail, subject: "Your vacancy was published on JobsGalore!")
  end
end