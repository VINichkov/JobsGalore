# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

a = Product.find_or_create_by(name: 'Job_Urgent')
a.update(price: {
    'AUD':  {price: '15.00', price_integer: 15},
    'USD':  {price: '15.00', price_integer: 15},
    'CAD':  {price: '15.00', price_integer: 15},
    'GBR':  {price: '12.00', price_integer: 12},
    'EUR':  {price: '13.00', price_integer: 12},
    'INR':  {price: '400', price_integer: 400},
    'RUB':  {price: '400', price_integer: 400},
    'CNY':  {price: '100', price_integer: 100}
})

a = Product.find_or_create_by(name: 'Job_Highlight')
a.update(price: {
    'AUD':  {price: '10.00', price_integer: 10},
    'USD':  {price: '10.00', price_integer: 10},
    'CAD':  {price: '10.00', price_integer: 10},
    'GBR':  {price: '8.00', price_integer: 8},
    'EUR':  {price: '9.00', price_integer: 9},
    'INR':  {price: '250', price_integer: 250},
    'RUB':  {price: '300', price_integer: 300},
    'CNY':  {price: '65', price_integer: 65}
})

a = Product.find_or_create_by(name: 'Job_Urgent_And_Highlight')
a.update(price: {
    'AUD':  {price: '22.00', price_integer: 22},
    'USD':  {price: '22.00', price_integer: 22},
    'CAD':  {price: '22.00', price_integer: 22},
    'GBR':  {price: '18.00', price_integer: 18},
    'EUR':  {price: '20.00', price_integer: 20},
    'INR':  {price: '550', price_integer: 550},
    'RUB':  {price: '600', price_integer: 600},
    'CNY':  {price: '150', price_integer: 150}
})



a = Product.find_or_create_by(name: 'Resume_Urgent')
a.update(price: {
    'AUD':  {price: '8.00', price_integer: 8},
    'USD':  {price: '8.00', price_integer: 8},
    'CAD':  {price: '8.00', price_integer: 8},
    'GBR':  {price: '6.00', price_integer: 6},
    'EUR':  {price: '6.00', price_integer: 6},
    'INR':  {price: '200', price_integer: 200},
    'RUB':  {price: '200', price_integer: 200},
    'CNY':  {price: '50', price_integer: 50}
})

a = Product.find_or_create_by(name: 'Resume_Highlight')
a.update(price: {
    'AUD':  {price: '5.00', price_integer: 5},
    'USD':  {price: '5.00', price_integer: 5},
    'CAD':  {price: '5.00', price_integer: 5},
    'GBR':  {price: '4.00', price_integer: 4},
    'EUR':  {price: '4.00', price_integer: 4},
    'INR':  {price: '130', price_integer: 130},
    'RUB':  {price: '150', price_integer: 150},
    'CNY':  {price: '35', price_integer: 35}
})

a = Product.find_or_create_by(name: 'Resume_Urgent_And_Highlight')
a.update(price: {
    'AUD':  {price: '11.00', price_integer: 11},
    'USD':  {price: '11.00', price_integer: 11},
    'CAD':  {price: '11.00', price_integer: 11},
    'GBR':  {price: '9.00', price_integer: 9},
    'EUR':  {price: '9.00', price_integer: 9},
    'INR':  {price: '280', price_integer: 280},
    'RUB':  {price: '300', price_integer: 300},
    'CNY':  {price: '75', price_integer: 75}
})

