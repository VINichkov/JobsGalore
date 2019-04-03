class ApplicationMailer < ActionMailer::Base
  helper(EmailHelper)
  default from: "#{PropertsHelper::COMPANY} <#{ENV["EMAIL_LOGIN"]}>"
  layout 'mailer'

  def create_utm(utm_campaign)
    {:utm_source=>:email, :utm_medium=>:email, :utm_campaign=>utm_campaign}.to_query
  end
end
