class ResumesMailer < ApplicationMailer

  def add_resume(resume)
    @resume = resume
    mail(to:@resume[:mail], subject: "Your resume was published on JobsGalore!")
  end

  def send_to_employer(resume, job, letter)
    Rails.logger.debug("Q_____________________________________________________________________!")
    @resume = resume
    @job = job
    @letter = letter
    mail(to:job.client.email, subject: job.title)
  end

end