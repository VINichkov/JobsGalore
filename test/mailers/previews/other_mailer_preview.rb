# Preview all emails at http://localhost:3000/rails/mailers/other_mailer/*
class OtherMailerPreview < ActionMailer::Preview
  def the_resume_has_posted
    params = {name: "Igor", email: "igor@mail.eu", password: "any"}
    OtherMailer.the_resume_has_posted('v.nichkov@hotmail.com', "Re: New resume", params)
  end
end