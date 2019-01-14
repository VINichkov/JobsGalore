class ApplicationMailer < ActionMailer::Base
  #default from: "#{PropertsHelper::COMPANY} <#{PropertsHelper::EMAIL}>"
  default from: ENV["EMAIL_LOGIN"]
  layout 'mailer'
end
