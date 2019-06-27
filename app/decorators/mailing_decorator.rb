# frozen_string_literal: true

class MailingDecorator < ApplicationDecorator
  delegate_all

  def payment_url
    if object.aasm_state == 'expect_the_payment'
      h.paypal_url(
        return_url: h.show_mailings_url,
        cancel_url: h.show_mailings_url,
        item_number: "44#{object.id}",
        item_name: 'mailing',
        price: object.price
      )
    end
  end
end
