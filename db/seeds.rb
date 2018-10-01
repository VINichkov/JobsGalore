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

    Resume.all.each do |resume|
      if resume.description.present?
        begin
        resume.description = RDiscount.new(resume.description)&.to_html.to_s
        resume.save!
        rescue
          puts "Resume Ошибка #{$!} id #{resume.id}"
        end
      end
    end

    Job.all.each do |job|
      if job.description.present?
        begin
        job.description = RDiscount.new(job.description)&.to_html.to_s
        job.save!
        rescue
          puts "Job Ошибка #{$!} id #{job.id}"
        end
      end
    end
    Company.all.each do |company|
      if company.description.present?
        begin
        company.description = RDiscount.new(company.description)&.to_html.to_s
        company.save!
        rescue
          puts "Company Ошибка #{$!} id #{company.id}"
        end
      end
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


