class ContactUsMailer < ApplicationMailer
  default from: "slava.nichkov@gmail.com"

  def send_mail(email)
    @email = email
    mail(to:PropertsHelper::EMAIL, subject: "Contact")
  end
end
