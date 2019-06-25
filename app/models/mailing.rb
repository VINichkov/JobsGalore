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
end
