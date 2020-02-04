# frozen_string_literal: true

module Services
  URGENT = OpenStruct.new name: 'Urgent', price: '15.00', price_integer: 15
  TOP = OpenStruct.new name: 'Ad Top', price: '20.00'
  HIGHLIGHT = OpenStruct.new name: 'Highlight', price: '10.00', price_integer: 10
  MAILING_RESUME_TO_COMPANY = OpenStruct.new(
    name: 'resume to companies',
    min_price: '5.00',
    one_email_price: '0.20',
    min_price_int: 5,
    one_email_price_float: 0.2
  )
  MAILING_ANY_AD_TO_COMPANY = OpenStruct.new(
    name: 'ad to companies',
    min_price: '10.00',
    one_email_price: '0.30',
    min_price_int: 10,
    one_email_price_float: 0.3
  )
  MAILING_TO_SEEKER = OpenStruct.new(
    name: 'letter to seekers',
    min_price: '5.00',
    one_email_price: '0.20',
    min_price_int: 5,
    one_email_price_float: 0.2
  )
end
