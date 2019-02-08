class ApplicationMailer < ActionMailer::Base
  helper(EmailHelper)
  default from: "#{PropertsHelper::COMPANY} <#{ENV["EMAIL_LOGIN"]}>"
  layout 'mailer'
end
