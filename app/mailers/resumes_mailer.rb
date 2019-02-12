class ResumesMailer < ApplicationMailer

  def add_resume(resume)
    @utm = {:utm_source=>:email, :utm_medium=>:email, :utm_campaign=>:new_resume}.to_query
    @resume = resume
    mail(to:@resume[:mail], subject: "Your resume was just posted on Jobs Galore!")
  end

  def send_to_employer(resume, job, letter, copy =nil)
    @utm = {:utm_source=>:email, :utm_medium=>:email, :utm_campaign=>:letter_to_employer}.to_query
    @resume, @job, @letter = resume, job, letter
    client = (!copy ? job.client.email : PropertsHelper::ADMIN)
    attachments["#{@resume.client.full_name}.pdf"] = @resume.to_pdf
    mail(to: client, subject: job.title)
  end

  def send_message(resume, letter, client, copy = nil)
    @utm = {:utm_source=>:email, :utm_medium=>:email, :utm_campaign=>:letter_to_applicant}.to_query
    @letter, @client, @resume = letter, client, resume
    client = (!copy ? @resume.client.email : PropertsHelper::ADMIN)
    mail(to:client, subject: @resume.title)
  end

end