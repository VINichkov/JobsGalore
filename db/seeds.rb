# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

##Загрузка json файлов
require 'mechanize'
require 'bcrypt'

#version 1
if 1 == 1

  JSON.parse(File.read('./db/import/1Location_do_not_work2.json'))["Location"].each do |local|
    Location.where(suburb: local['suburb'], state:local['state']).first_or_create(postcode: local['postcode'],suburb: local['suburb'].downcase.capitalize, state:local['state'])
  end

  puts "--==Clients #{Client.count}==--"
  puts "--==Companies #{Company.count}==--"
  puts "--==Industries #{Industry.count}==--"
  puts "--==Jobs #{Job.count}==--"
  puts "--==Locations #{Location.count}==--"
  puts "--==Properts #{Propert.count}==--"
  puts "--==Resumes #{Resume.count}==--"
  puts "--==Sizes #{Size.count}==--"
end


