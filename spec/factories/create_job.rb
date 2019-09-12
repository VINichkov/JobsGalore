FactoryBot.define do
  factory :location_omsk, class: Location do
    postcode { '64400' }
    suburb { 'Omsk' }
    state { 'OMS' }
  end

  city = FactoryBot.create :location_omsk

  factory :client, class: Client do
    firstname { 'Nikol' }
    lastname { 'Kidman' }
    email { 'nikol.k@mail.com' }
    phone { Faker::PhoneNumber.phone_number }
    password { '11111111' }
    location_id { city.id }
  end

  factory :company, class: Company do
    name { 'Best Company' }
    location { city }
  end

  factory :create_job do
    email    { Faker::Internet.email }
    password { '11111111' }
    location_id { city.id }
    location_name { city.suburb }
    title { 'Barista' }
    salarymin { 10000 }
    salarymax { 1000000 }
    description { '<p> We created a new job! </p>' }
    company_name { 'Best Company'}
    full_name { 'Sarah Smith' }
  end
end