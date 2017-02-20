# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



##
#puts "== #{Time.now} Delete all======================="
#begin
#  Client.delete_all
#  Company.delete_all
#  Experience.delete_all
#  Industrycompany.delete_all
#  Industryexperience.delete_all
#  Industryjob.delete_all
#  Industryresume.delete_all
#  Job.delete_all
#  Languageresume.delete_all
#  Skillsjob.delete_all
#  Skillsresume.delete_all
#rescue
#  puts "Error: #{$!}"
#end
##

##Загрузка json файлов
require 'mechanize'

if 1==1
# Блок загрузки файлов
ttime =Time.now
puts "== #{ttime} start seed"
Dir["./db/import/*"].sort.each do |path|
  begin
    unless path=="./db/import/redme.txt"
      puts "== #{Time.now} import #{path}"
      file = JSON.parse(File.read(path))
      file.each do |name,array|
        index={}
        timestart =Time.now
        puts "== #{timestart} cleaning table #{name}"
        case name
          when "Company"
            index[:location] = {min: Location.ids.min, count: Location.count}
            index[:size] = {min:Size.ids.min, count:Size.count}
          when "Client"
            index[:location] = {min: Location.ids.min, count: Location.count}
          when "Industry"
            index[:level]={min:Level.ids.min, count:Level.count}
        end
        eval "#{name}.destroy_all"
        puts "== #{Time.now-timestart} end"
        timestart =Time.now
        puts "== #{timestart} data recording"
        i=0
        time_start = Time.now
        array.each do |elem|
          arg = "#{name}.create("
          elem.each do |key, value|
            if  name =="Company"
                case key
                  when "location"
                    arg+="#{key}:Location.find_by_id(#{index[:location][:min]+Random.rand(index[:location][:count])}),"
                  when "size"
                    arg+="#{key}:Size.find_by_id(#{index[:size][:min]+Random.rand(index[:size][:count])}),"
                  else
                    arg+="#{key}:\"#{value}\","
                end
            else
            arg+="#{key}:\"#{value}\","
            end
          end

          if name=="Client"
            arg+="location:Location.find_by_id(#{index[:location][:min]+Random.rand(index[:location][:count])}))"
          else
            arg[arg.length-1]=')'
          end
          puts arg
          eval arg
          i+=1
          if i%100==0
            time_start = Time.now
          end
        end
        puts "== #{Time.now-timestart} end #{eval("#{name}.count")}"
      end
    end
  rescue
    puts "Error: #{$!}"
  end
end # Конец блока  загрузки файлов

begin
    #Обработка клиентов
    timestart =Time.now
    i=0
    puts "== #{timestart} start normalization Client 1"
    Client.where("email='' or email='почты@нет'").each do |client|
        client.update(email:"email#{client.id}@mail.com")
        i+=1
        puts "== #{Time.now-timestart} complete #{i} row" if (i%1000==0)
    end
    puts "== #{Time.now-timestart} end"

    timestart =Time.now
    i=0
    puts "== #{timestart} start normalization Client 2"
    sql = "select cl.* from clients cl,(select email from clients GROUP BY email HAVING count(email)>1) cl2 WHERE cl.email=cl2.email"
    Client.find_by_sql(sql).each do |client|
      client.update(email:"email#{client.id}@mail.com")
      i+=1
      if (i%1000==0)
        puts "== #{Time.now-timestart} complete #{i} row"
        timestart =Time.now
      end
    end
    puts "== #{Time.now-timestart} end"
    #Конец обработки клиентов

    #Нахначение отверственных по конманиям
    if Responsible.count==0

      i=0
      puts "== #{timestart} Linking customers to the company"
      count_client = Client.count
      min_id_client = Client.ids.min
      Company.all.each do |company|
        client=Client.find_by_id(min_id_client+Random.rand(count_client))
        Responsible.create(company: company, client:client)
        #####client.update(responsible: true)
        #i+=1
        #puts "== #{Time.now-timestart} complete #{i} row" if (i%1000==0)
      end
      puts "== #{Time.now-timestart} end"
    end
    #Конец

    #Присвоение индустрий компаниям
    if Industrycompany.count==0
      mestart =Time.now
      i=0
      puts "== #{timestart} Linking industry to the company"
      index = {count: Industry.count, min: Industry.ids.min}
      Company.all.each do |company|
        j=1+Random.rand(3)
        while j>0 do
          flag=true
          while flag  do
            industry=Industry.find_by_id(index[:min]+Random.rand(index[:count]))
            if Industrycompany.where("industry_id=:industry and company_id=:company", industry: industry.id,company:company.id).count==0
              flag=false
            end
          end
          Industrycompany.create(company: company, industry:industry)
          j-=1
        end
        i+=1
        puts "== #{Time.now-timestart} complete #{i} row" if (i%1000==0)
      end
      puts "== #{Time.now-timestart} end"
    end
    #Конец

    #Создаем вакансии
    if Job.count== 0
      timestart =Time.now
      puts "== #{timestart} create job"
      #Создание массива со словами
      file = File.open('./db/tools/words.txt') do |file|
        file.read
      end
      arr_word = file.split
      #Конец блока создания массива

      #Подготовка переменных
      index= {location: {min: Location.ids.min, count: Location.count}}
      index[:industry] = {min: Industry.ids.min, count: Industry.count}
      index[:arr] = {count:arr_word.count}
      #Конец подготовки
      company = Company.first
        if 1==1 #Random.rand(2)==1
          job_count = Random.rand(51)
          while job_count>0

            #Расчет параметров для каждой вакансии
            #З.П
            if  Random.rand(2)==1 #Есть з.п
              salarymin=Random.rand(110)*1000 if Random.rand(2)==1
              if Random.rand(2)==1 #есть максимальная з.п. но нет минимальной
                salarymax = Random.rand(180)*1000
              elsif Random.rand(2)==1 and not(salarymin.nil?)
                salarymax = salarymin+Random.rand(70)*1000
              end
            else
              salarymin=nil
              salarymax=nil
            end

            #описание
            description = ''
            i=Random.rand(100)
            while i>0
              description += arr_word[Random.rand(index[:arr][:count])]+' '
              i-=1
            end

            #Создаем вакансию
            job = company.job.create(title:'тест',
                                       location: Location.find_by_id(index[:location][:min] + Random.rand(index[:location][:count])),
                                       salarymin: salarymin,
                                       salarymax: salarymax,
                                       permanent: [true, false].sample,
                                       casual: [true, false].sample,
                                       temp: [true, false].sample,
                                       contract: [true, false].sample,
                                       fulltime: [true, false].sample,
                                       parttime: [true, false].sample,
                                       flextime: [true, false].sample,
                                       remote: [true, false].sample,
                                       description: description)
            job.save

            #Добавляем к вакансии отрасли
            if 1==1
            industry_count = Random.rand(3)
            puts "Будет #{industry_count+1} итераций"
            i=0
            arr_industry=[]
            while industry_count>=i
              puts "Итерация #{i}"
              industry=Industry.find_by_id(index[:industry][:min] + Random.rand(index[:industry][:count]))
              if arr_industry.count>=1
                puts "Итерация #{i} проверяем #{industry.name}"
                arr_industry.each do |elem|
                  if elem==industry
                    puts "Итерация #{i} нашли повтор #{industry.name}"
                  else
                    puts "Итерация #{i} Повтора нет #{industry.name}"
                    arr_industry[i]=industry
                    i+=1
                  end
                end
              else
                puts "Итерация #{i} все записываем в массив бес проверки"
                arr_industry[i]=industry
                i+=1
              end
            end
            arr_industry.each do  |elem|
              puts elem.name
            end
            end
              industry = Industry.f
              job = Job.first.industryjob.create(industry: I)


            job_count-=1
          end
        end
      #end
      puts "== #{Time.now-timestart} end"
    end

    #

rescue
  puts "Error: #{$!}"
end

puts "== #{Time.now - ttime } end seed"
end


=begin
#В дальнейшем будет парсер. Пока не делаем.
#забираем данные с carearone.com.au
a = Mechanize.new do |agent|
  agent.user_agent_alias = 'Windows Firefox'
end
b=''
a.get('http://www.careerone.com.au/search?search_company=&search_keywords=&search_category=&search_location=&search_job_type=&search_salary_min=&search_salary_max=&search_job_type=&search_salary_min=&search_salary_max=') do |p|
  b += p.search("div|class").to_s
end

puts b
=end
