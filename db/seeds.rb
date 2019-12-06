# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

a = Product.find_or_create_by(name: 'Job_Urgent')
a.update(price: {
    'AUD':  {price: 14.99},
    'USD':  {price: 14.99},
    'CAD':  {price: 14.99},
    'GBR':  {price: 11.99},
    'EUR':  {price: 12.99},
    'INR':  {price: 399},
    'RUB':  {price: 399},
    'CNY':  {price: 71}
})

a = Product.find_or_create_by(name: 'Job_Highlight')
a.update(price: {
    'AUD':  {price: 9.99},
    'USD':  {price: 9.99},
    'CAD':  {price: 9.99},
    'GBR':  {price: 7.99},
    'EUR':  {price: 8.99},
    'INR':  {price: 249},
    'RUB':  {price: 299},
    'CNY':  {price: 47}
})

a = Product.find_or_create_by(name: 'Job_Urgent_And_Highlight')
a.update(price: {
    'AUD':  {price: 21.99},
    'USD':  {price: 21.99},
    'CAD':  {price: 21.99},
    'GBR':  {price: 17.99},
    'EUR':  {price: 19.99},
    'INR':  {price: 549},
    'RUB':  {price: 599},
    'CNY':  {price: 99}
})

a = Product.find_or_create_by(name: 'Resume_Urgent')
a.update(price: {
    'AUD':  {price: 5.99},
    'USD':  {price: 5.99},
    'CAD':  {price: 5.99},
    'GBR':  {price: 4.99},
    'EUR':  {price: 4.99},
    'INR':  {price: 159},
    'RUB':  {price: 199},
    'CNY':  {price: 28}
})

a = Product.find_or_create_by(name: 'Resume_Highlight')
a.update(price: {
    'AUD':  {price: 4.99},
    'USD':  {price: 4.99},
    'CAD':  {price: 4.99},
    'GBR':  {price: 3.99},
    'EUR':  {price: 3.99},
    'INR':  {price: 129},
    'RUB':  {price: 149},
    'CNY':  {price: 23}
})

a = Product.find_or_create_by(name: 'Resume_Urgent_And_Highlight')
a.update(price: {
    'AUD':  {price: 8.99},
    'USD':  {price: 8.99},
    'CAD':  {price: 8.99},
    'GBR':  {price: 6.99},
    'EUR':  {price: 6.99},
    'INR':  {price: 259},
    'RUB':  {price: 329},
    'CNY':  {price: 45}
})

