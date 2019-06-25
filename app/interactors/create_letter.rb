# frozen_string_literal: true

class CreateLetter
  include Interactor

  def call
    letter = context.params
    mailing = {}
    mailing[:offices] = EmailHr.where(id: letter['recipients']).includes(:location, :company).map do |recipient|
      { company: recipient.company.name,
        recipient: recipient.fio,
        main: recipient.main,
        area: recipient.location_id ? recipient.location.name : 'Australia' }
    end
    mailing[:message] = letter['message']
    mailing[:client_id] = context.client
    mailing[:resume_id] = letter['resume']
    mailing[:price] = letter['price'].to_f
    mailing[:type_letter] = letter['type']
    new_letter = Mailing.new(mailing)
    context.fail! unless new_letter.save
    content.url(
      id: new_letter.id,
      type: 4,
      item_number: "44#{new_letter.id}",
      item_name: 'mailing',
      price: new_letter.price
    )
  end
end
