# Preview all emails at http://localhost:3000/rails/mailers/jobs_mailer/*
class JobsMailerPreview < ActionMailer::Preview

  def add_job
    JobsMailer.add_job(Job.last)
  end

  def daily_job_alert
    JobsMailer.daily_job_alert("mail@email.com", Job.where(company_id: 8159).limit(10))
  end

  def turn_on_option
    JobsMailer.turn_on_option("Urgent", Job.find_by_id(275320))
  end

  def turn_off_option
    JobsMailer.turn_off_option("Urgent", Job.find_by_id(275320))
  end

  def notice_remove_job
    JobsMailer.notice_remove_job(2, Job.find_by_id(275320))
  end

  def remove_job
    JobsMailer.remove_job(Job.find_by_id(275320))
  end
end