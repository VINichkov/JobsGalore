class Mailing < ApplicationRecord
  include AASM
  belongs_to :client
  belongs_to :resume

  def to_h
    {id: id,
     recipients: offices,
     created_at: created_at.to_date,
     message: markdown_to_text(message, 300),
     amount: price,
     status: status
    }
  end


  aasm do
    state :expect_the_payment, initial: true
    state :approval
    state :finished

    event :pay do
      transitions from: :expect_the_payment, to: :approval
    end

    event :affirm, after: :sending_emails do
      transitions from: :approval, to: :finished
    end

  end


  def status
    res = {
        expect_the_payment: "Expect the payment",
        approval: "Pending approval",
        finished: "Sent"
    }
    res[self.aasm_state.to_sym]
  end

  def sending_emails
    if self.type_letter == 'resume to companies' || self.type_letter == 'ad to companies'
      Rails.logger.info("Send email from #{self.client.email}")
      pdf = Base64.encode64(resume.to_pdf) if resume.present?
      self.offices.each do |t|
        MailingMailer.send_resume_to_company(self, t["email"], pdf).deliver_now
      end
      MailingMailer.send_resume_to_company(self, PropertsHelper::ADMIN, pdf).deliver_now
    end
  end
end
