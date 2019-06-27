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

    event :affirm do
      transitions from: :approval, to: :finished
    end

  end

  private

  def status
    res = {
        expect_the_payment: "Expect the payment",
        approval: "Pending approval",
        finished: "Sent"
    }
    res[self.aasm_state.to_sym]
  end

  def sending_emails
    if type_letter == "resume to companies" && resume.present?
      pdf = resume.to_pdf
      title = resume.title
      self.offices.each do |t|
        MailingMailer.send_resume_to_company(self, t["email"], pdf, title).deliver_later
      end
      MailingMailer.send_resume_to_company(self, PropertsHelper::ADMIN, pdf, title).deliver_later
    end
  end
end
