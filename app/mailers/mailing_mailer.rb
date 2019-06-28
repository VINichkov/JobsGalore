class MailingMailer < ApplicationMailer

  def send_resume_to_company(letter, email, pdf = nil)
    attachments["#{letter.client.full_name}.pdf"] = pdf if pdf
    @letter, @email = letter, email
    @utm = create_utm(:send_resume_to_company)
    mail(to:email, subject: 'New message from jobsgalore.eu')
  end
end