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
if 1==1
  begin
    Client.all.each do |client|
      if client.character == 'Aplicant'
        client.character = "Applicant"
      end
    end
  rescue
    puts "Error: #{$!}"
  end
  puts "--==Clients #{Client.count}==--"
  puts "--==Companies #{Company.count}==--"
  puts "--==Educations #{Education.count}==--"
  puts "--==Experiences #{Experience.count}==--"
  puts "--==Industries #{Industry.count}==--"
  puts "--==IndustryCompanies #{Industrycompany.count}==--"
  puts "--==IndustryExperiences #{Industryexperience.count}==--"
  puts "--==IndustryJobs #{Industryjob.count}==--"
  puts "--==IndustryResumes #{Industryresume.count}==--"
  puts "--==Jobs #{Job.count}==--"
  puts "--==Languageresumes #{Languageresume.count}==--"
  puts "--==Languages #{Language.count}==--"
  puts "--==Levels #{Level.count}==--"
  puts "--==Locations #{Location.count}==--"
  puts "--==Properts #{Propert.count}==--"
  puts "--==Responsibles #{Responsible.count}==--"
  puts "--==Resumes #{Resume.count}==--"
  puts "--==Sizes #{Size.count}==--"
  puts "--==Skillsjobs #{Skillsjob.count}==--"
  puts "--==SkillsResumes #{Skillsresume.count}==--"


end


