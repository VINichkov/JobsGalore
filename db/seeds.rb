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
if 1 == 2

  puts "--==Clients #{Client.count}==--"
  puts "--==Companies #{Company.count}==--"
  puts "--==Industries #{Industry.count}==--"
  puts "--==Jobs #{Job.count}==--"
  puts "--==Locations #{Location.count}==--"
  puts "--==Properts #{Propert.count}==--"
  puts "--==Resumes #{Resume.count}==--"
  puts "--==Sizes #{Size.count}==--"
end


