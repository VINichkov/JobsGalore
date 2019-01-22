class ResumesMailer < ApplicationMailer

  def add_resume(resume)
    @resume = resume
    mail(to:@resume[:mail], subject: "Your resume was just posted on Jobs Galore!")
  end

  def send_to_employer(resume, job, letter)
    @resume, @job, @letter = resume, job, letter
    attachments["#{@resume.client.full_name}.pdf"] = @resume.to_pdf
    mail(to:job.client.email, subject: job.title)
  end

  def send_message(resume, letter, client)
    @letter, @client, @resume = letter, client, resume
    mail(to:@resume.client.email, subject: @resume.title)
  end

end