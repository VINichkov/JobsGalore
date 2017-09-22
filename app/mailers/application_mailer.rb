class ApplicationMailer < ActionMailer::Base
  default from: "#{PropertsHelper::COMPANY} <#{PropertsHelper::EMAIL}>"
  layout 'mailer'
end
