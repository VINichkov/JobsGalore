# Preview all emails at http://localhost:3000/rails/mailers/resumes_mailer
class ResumesMailerPreview < ActionMailer::Preview
  def send_mail
    ContactUsMailer.send_mail(email: "Тестовый емеил")
  end

  def add_resume
    resume = Resume.last
    ResumesMailer.add_resume({mail: resume.client.email, firstname: resume.client.full_name, id: resume.id, title: resume.title})
  end

  def send_to_employer(resume, job, pdf, letter, copy =nil)
    @utm = {:utm_source=>:email, :utm_medium=>:email, :utm_campaign=>:letter_to_employer}.to_query
    @resume, @job, @letter = resume, job, letter
    client = (!copy ? job.client.email : PropertsHelper::ADMIN)
    attachments["#{@resume.client.full_name}.pdf"] = pdf
    mail(to: client, subject: job.title)
  end

  def send_message(resume, letter, client, copy = nil)
    @utm = {:utm_source=>:email, :utm_medium=>:email, :utm_campaign=>:letter_to_applicant}.to_query
    @letter, @client, @resume = letter, client, resume
    client = (!copy ? @resume.client.email : PropertsHelper::ADMIN)
    mail(to:client, subject: @resume.title)
  end

end