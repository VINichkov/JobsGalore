class ContactUsMailer < ApplicationMailer


  def send_mail(email)
    @email = email
    mail(to:'v.nichkov@hotmail.com', subject: "Contact")
  end

  def send_to_customers(mail)
      mail(to:mail, subject: "New website of jobs. We offer to join.")
  end
end
