class ContactUsMailer < ApplicationMailer
  default from: "#{PropertsHelper::COMPANY} <#{PropertsHelper::EMAIL}>"

  def send_mail(email)
    @email = email
    mail(to:'v.nichkov@hotmail.com', subject: "Contact")
  end

  def send_to_customers
    puts "Поехали!"
    Email.all.each do |adress|
      puts "письмо"
      mail(to:adress, subject: "New website of jobs. We offer to join.")
    end
    mail(to:'v.nichkov@hotmail.com', subject: "Well Done!!!")
  end
end
