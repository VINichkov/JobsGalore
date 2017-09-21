class ResumesMailer < ApplicationMailer
  default from: "#{PropertsHelper::COMPANY} <#{PropertsHelper::EMAIL}>"

  def add_resume(mail)
    mail(to:mail, subject: "Your resume was published on JobsGalore!")
  end
end