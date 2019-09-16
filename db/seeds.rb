# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

##Загрузка json файлов
#require 'mechanize'
require 'bcrypt'
if ENV["RAILS_ENV"] == "test"
  Propert.create([
    {code: 'port', name: 'port', value:  80},
    {code: 'host_name', name: 'host', value:  'https://www.jobsgalore.eu'},
    {code: 'title', name: 'Name this site', value:  'JobsGalore'},
    {code: 'company', name: 'Company', value:  'JobsGalore'},
    {code: 'email', name: 'Email', value:  'email@jobsgalore.eu'},
    {code: 'confirm', name: "confirm's Email", value:  'email@jobsgalore.eu'},
    {code: 'admin', name: "Admin's email", value:  'v.nichkov@hotmail.com'},
    {code: 'recoverable', name: 'recoverable email', value:  'email@jobsgalore.eu'},
    {code: 'urgent', name: 'Urgent', value:  'true'},
    {code: 'highlight', name: 'Highlight', value:  'true'},
    {code: 'top', name: 'Ad Top', value:  'false'}
  ])
end
#version 1
if 1 == 2

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


