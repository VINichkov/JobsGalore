# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

=begin
a = Product.find_or_create_by(name: 'Job_Urgent')
a.update(price: {
    'AUD':  {price: 14.99},
    'USD':  {price: 14.99},
    'CAD':  {price: 14.99},
    'GBR':  {price: 9.99},
    'EUR':  {price: 9.99},
    'RUB':  {price: 399},
})

a = Product.find_or_create_by(name: 'Job_Highlight')
a.update(price: {
    'AUD':  {price: 9.99},
    'USD':  {price: 9.99},
    'CAD':  {price: 9.99},
    'GBR':  {price: 6.99},
    'EUR':  {price: 6.99},
    'RUB':  {price: 299},
})

a = Product.find_or_create_by(name: 'Job_Urgent_And_Highlight')
a.update(price: {
    'AUD':  {price: 21.99},
    'USD':  {price: 21.99},
    'CAD':  {price: 21.99},
    'GBR':  {price: 14.99},
    'EUR':  {price: 14.99},
    'RUB':  {price: 599},
})

a = Product.find_or_create_by(name: 'Resume_Urgent')
a.update(price: {
    'AUD':  {price: 5.99},
    'USD':  {price: 5.99},
    'CAD':  {price: 5.99},
    'GBR':  {price: 4.99},
    'EUR':  {price: 4.99},
    'RUB':  {price: 199},
})

a = Product.find_or_create_by(name: 'Resume_Highlight')
a.update(price: {
    'AUD':  {price: 4.99},
    'USD':  {price: 4.99},
    'CAD':  {price: 4.99},
    'GBR':  {price: 3.99},
    'EUR':  {price: 3.99},
    'RUB':  {price: 149},
})

a = Product.find_or_create_by(name: 'Resume_Urgent_And_Highlight')
a.update(price: {
    'AUD':  {price: 8.99},
    'USD':  {price: 8.99},
    'CAD':  {price: 8.99},
    'GBR':  {price: 6.99},
    'EUR':  {price: 6.99},
    'RUB':  {price: 329},
})

a = Product.find_or_create_by(name: 'Mailing_Resume_To_Company_Min_Price')
a.update(price: {
    'AUD':  {price: 4.99},
    'USD':  {price: 4.99},
    'CAD':  {price: 4.99},
    'GBR':  {price: 3.99},
    'EUR':  {price: 3.99},
    'RUB':  {price: 149},
})

a = Product.find_or_create_by(name: 'Mailing_Resume_To_Company_One_Email_Price')
a.update(price: {
    'AUD':  {price: 0.20},
    'USD':  {price: 0.20},
    'CAD':  {price: 0.20},
    'GBR':  {price: 0.15},
    'EUR':  {price: 0.15},
    'RUB':  {price: 12},
})

a = Product.find_or_create_by(name: 'Mailing_Any_Ads_To_Company_Min_Price')
a.update(price: {
    'AUD':  {price: 9.99},
    'USD':  {price: 9.99},
    'CAD':  {price: 9.99},
    'GBR':  {price: 6.99},
    'EUR':  {price: 6.99},
    'RUB':  {price: 299},
})

a = Product.find_or_create_by(name: 'Mailing_Any_Ads_To_Company_One_Email_Price')
a.update(price: {
    'AUD':  {price: 0.30},
    'USD':  {price: 0.30},
    'CAD':  {price: 0.30},
    'GBR':  {price: 0.20},
    'EUR':  {price: 0.20},
    'RUB':  {price: 18},
})=end

