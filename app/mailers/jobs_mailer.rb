class JobsMailer < ApplicationMailer


  def add_job(user,job)
    @user,@job = user,job
    mail(to:user.email, subject: "Your vacancy was published on JobsGalore!")
  end
end