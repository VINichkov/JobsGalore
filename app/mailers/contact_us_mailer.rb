class ContactUsMailer < ApplicationMailer
  default from: "#{PropertsHelper::COMPANY} <#{PropertsHelper::EMAIL}>"

  def send_mail(email)
    @email = email
    mail(to:'v.nichkov@hotmail.com', subject: "Contact")
  end
end
