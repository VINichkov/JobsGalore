# Preview all emails at http://localhost:3000/rails/mailers/resumes_mailer
class ResumesMailerPreview < ActionMailer::Preview

  def add_resume
    ResumesMailer.add_resume(Resume.last)
  end

  def remove_resume
    ResumesMailer.remove_resume(Resume.last)
  end

  def turn_on_option
    ResumesMailer.turn_on_option("Urgent", Resume.find_by_id(43))
  end

  def turn_off_option
    ResumesMailer.turn_off_option("Urgent", Resume.find_by_id(43))
  end

  def send_to_employer(resume, job, pdf, letter, copy =nil)
    @utm = {:utm_source=>:email, :utm_medium=>:email, :utm_campaign=>:letter_to_employer}.to_query
    @resume, @job, @letter = resume, job, letter
    client = (!copy ? job.client.email : PropertsHelper::ADMIN)
    attachments["#{@resume.client.full_name}.pdf"] = pdf
    mail(to: client, subject: job.title)
  end

  def send_message
    letter = <<-TEXT
    <p>Hi,</p>
    <p>I\'m interested in the " +this.props.title.name+" job which I found on <a href=\"www.jobsgalore.eu\">Jobs Galore</a>. 
    I believe I have the appropriate experience for this role. Please contact me if you would like to discuss further.</p>
    <p>I look forward to hearing from you.</p>
    TEXT
    ResumesMailer.send_message(Resume.last, letter, Client.offset(rand(Client.count)).first)
  end

end