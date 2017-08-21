class ContactUsMailer < ApplicationMailer
  default from: "email@jobsgalore.eu"

  def send_mail(email)
    @email = email
    mail(to:PropertsHelper::EMAIL, subject: "Contact")
  end
end
