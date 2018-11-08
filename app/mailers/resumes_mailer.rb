class ResumesMailer < ApplicationMailer

  def add_resume(resume)
    @resume = resume
    mail(to:@resume[:mail], subject: "Your resume was published on Jobs Galore!")
  end

  def send_to_employer(resume, job, letter)
    @resume, @job, @letter = resume, job, letter
    @resume.decorate
    puts @resume.class
    attachments["#{@resume.client.full_name}.pdf"] = @resume.to_pdf
    mail(to:job.client.email, subject: job.title)
  end

end