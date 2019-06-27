class MailingMailer < ApplicationMailer

  def send_resume_to_company(letter, email, pdf, title_of_resume)
    attachments["#{client.full_name}.pdf"] = pdf
    @letter, @email, @title_of_resume = letter, email, title_of_resume
    @utm = create_utm(:send_resume_to_company)
    mail(to:email, subject: 'New message from jobsgalore.eu')
  end
end