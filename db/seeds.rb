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
            index[:location] = Location.all.ids
            index[:size] = Size.all.ids
          when "Client"
            index[:location] = Location.all.ids
            index[:password] = BCrypt::Password.create('11111111')
          when "Industry"
            index[:level]={min:Level.ids.min, count:Level.count}
        end
        eval "#{name}.destroy_all"
        puts "== #{Time.now-timestart} end"
        timestart =Time.now
        t=Time.now
        puts "== #{timestart} data recording"
        i=0
        time_start = Time.now
        if name=="Client"
          r = 700
        elsif name=="Company"
          r = 300
        else
          r = array.length-1
        end
        array[0..r].each do |elem|
          if  name =="Company"
            elem[:location_id]=index[:location].sample
            elem[:size_id]=index[:size].sample
            elem.delete("size")
            elem.delete("location")
          elsif name=="Client"
            elem[:location_id]=index[:location].sample
            elem[:password] = index[:password]
            elem[:encrypted_password]= index[:password]
          end
          arg = "#{name}.create(#{elem.to_s})"
          eval arg
          i+=1
          puts "Сформироано #{i} записей за #{Time.now - t}" if i%100==0
          if i%1000==0
            index[:password] = BCrypt::Password.create('11111111')
            puts "== #{Time.now-timestart} complete #{i} row"
            time_start = Time.now
          end
        end
        puts "== #{Time.now-timestart} end #{eval("#{name}.count")}"
      end
    end
  rescue
    puts "____________________Error: #{$!}"
  end
end # Конец блока  загрузки файлов

begin

    arr_word=[]
    File.open('./db/tools/words.txt') do |file|
      arr_word=file.readlines
    end

    #Подготовка переменных
    index= {location: Location.all.ids}
    index[:industry] = Industry.all.ids
    index[:company] = Company.all.ids

    #Назначение отверственных по команиям
    puts "++ Responsible #{Responsible.count}"
    if Responsible.count==0
      timestart =Time.now
      i=0
      puts "== #{timestart} Linking customers to the company"
      count_client = Client.count
      min_id_client = Client.ids.min
      Company.all.each do |company|
        client=Client.find_by_id(min_id_client+Random.rand(count_client))
        Responsible.create(company: company, client:client)
        client.type ='employer'
      end
      puts "== #{Time.now-timestart} end"
    end
    #Конец

    puts "++ Industrycompany #{Industrycompany.count}"
    #Присвоение индустрий компаниям
    if Industrycompany.count==0
      timestart =Time.now
      i=0
      puts "== #{timestart} Linking industry to the company"
      Company.all.each do |company|
        j=1+Random.rand(2)
        while j>0 do
          flag=true
          while flag  do
            industry=index[:industry].sample
            if Industrycompany.where("industry_id=:industry and company_id=:company", industry: industry,company:company.id).count==0
              flag=false
            end
          end
          Industrycompany.create(company: company, industry_id:industry)
          j-=1
        end
        i+=1
        puts "== #{Time.now-timestart} complete #{i} row" if (i%1000==0)
      end
      puts "== #{Time.now-timestart} end"
    end
    #Конец

    puts "++ Job #{Job.count}"
    #Создаем вакансии
    if Job.count== 0

      timestart =Time.now
      puts "== #{timestart} create job"
      i=0
      Company.all.each do |company|
        if [false, true].sample
          Random.rand(15).times do

            #Расчет параметров для каждой вакансии
            title =rand(15).times.map do
              arr_word.sample.delete("\n")+' '
            end
            #З.П
            if  [false, true].sample #Есть з.п
              salarymin=rand(110)*1000 if [false, true].sample
              if [false, true].sample #есть максимальная з.п. но нет минимальной
                salarymax = rand(180)*1000
              elsif [false, true].sample and not(salarymin.nil?)
                salarymax = salarymin+rand(70)*1000
              end
            else
              salarymin=nil
              salarymax=nil
            end

            #описание
            description = rand(100).times.map do
              arr_word.sample.delete("\n")+' '
            end

            #Создаем вакансию
            job = Job.create(title:title.join,
                       company:company,
                                       location_id: index[:location].sample,
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
                                       description: description.join)

            #Добавляем к вакансии отрасли
            if job.save
            index_now  =index[:industry].sample
            rand(4).times do
              if index_now>Industry.all.ids.max
                index_now = Industry.all.ids.min
              end
              industry=job.industryjob.create(industry_id:index_now)
              industry.save
              index_now +=1
            end
              end

          end
        end
        i+=1
        puts "== #{Time.now-timestart} complete #{i} row" if (i%1000==0)
      end
      puts "== #{Time.now-timestart} end"
    end

    puts "++ Resumes #{Resume.count}"
    #Создаем резюме
    if Resume.count == 0
      #Конец подготовки
      #Оптимизируем деля по блокам
      # 1 Создаем резюме для клиентов
      # 2 Добавляем индустрию в резюме
      # 3 Для каждого резюме создаем опыт работы
      #Создание резюме
      i=0
      timestart =Time.now
      puts "== #{timestart} create resume"
      Client.where("type =\'employer\'").find_in_batches.each do |clients|
        clients.each do |client|
          if [true, false].sample
            rand(3).times
              #Расчет параметров для каждой вакансии
              desiredjobtitle = (rand(5)+1).times.map do
                arr_word.sample.delete("\n")+' '
              end
              salary = (rand(180)+1)*1000
              permanent = [false,true].sample
              casual = [false,true].sample
              temp = [false,true].sample
              contract = [false,true].sample
              fulltime = [false,true].sample
              parttime = [false,true].sample
              flextime = [false,true].sample
              remote = [false,true].sample
              abouteme=(rand(50)+1).times.map do
                arr_word.sample.delete("\n")+' '
              end

              Resume.create(client:client,
                            location:client.location,
                                  desiredjobtitle:desiredjobtitle.join,
                                  salary:salary,
                                  permanent:permanent,
                                  casual: casual,
                                  temp:temp,
                                  contract:contract,
                                  fulltime:fulltime,
                                  parttime:parttime,
                                  flextime:flextime,
                                  remote:remote,
                                  abouteme:abouteme.join)
            end
        end
        i+=1
        puts "== #{Time.now-timestart} complete #{i*1000} row"
      end
      puts "== #{Time.now-timestart} end"
    end
      #Добавляем индустрии к резюме
    if 1==1
      i=0
      #index = {industry:Industry.all.ids}
      timestart =Time.now
      puts "== #{timestart} match the resumes and industries"
      if Industryresume.count == 0
        Resume.find_in_batches.each do |resumes|
          resumes.each do |resume|
            Industryresume.create(industry_id: index[:industry].sample, resume:resume)
          end
          i+=1
          puts "== #{Time.now-timestart} complete #{i*1000} row"
        end
        puts "== #{Time.now-timestart} end"
      end
    end

      #Добавление опыта работы
    i=0
    timestart =Time.now
    puts "== #{timestart} add experiences"
    if Experience.count == 0
      Resume.find_in_batches.each do |resumes|
        experiences = []
        resumes.each do |resume|
          count_job= Random.rand(6)+1
          count_job.times do |i|
            #рассчитываем параметры для опыта
            employer = Company.find_by_id(index[:company].sample).name
            location = Location.find_by_id(index[:location].sample)
            site = "#{["https://","http://"].sample+employer.delete(" ",".","\\","/")+[".ru",".com.au",".com"].sample}#"
            titlejob = ""
            (Random.rand(5)+1).times do
              titlejob+=arr_word[Random.rand(arr_word.size)].delete("\n")+' '
            end
            datestart =Time.new.to_date - 365*(count_job-i)
            if count_job != i+1
              dateend = Time.new.to_date - 365*(count_job-(i+1))
            else
              dateend = nil
            end
            description =""
            (Random.rand(25)+1).times do
              description+=arr_word[Random.rand(arr_word.size)].delete("\n")+' '
            end
            experiences<<Experience.new(resume:resume,
                                        employer:employer,
                                        location:location,
                                        site:site,
                                        titlejob:titlejob,
                                        datestart:datestart,
                                        dateend:dateend,
                                        description:description)
          end
        end
        i+=1
        Experience.import experiences
        puts "== #{Time.now-timestart} complete #{i*1000} row"
      end
      puts "== #{Time.now-timestart} end"
    end

    #Связка индустрии и опыта
    if Industryexperience.count == 0
      i=0
      timestart =Time.now
      puts "== #{timestart} match industries and experiences"
      Experience.find_in_batches.each do |experiences|
        experiences.each do |experience|
         Industryexperience.create(experience:experience, industry_id: index[:industry].sample)
        end
        i+=1
        puts "== #{Time.now-timestart} complete #{i*1000} row"
      end
      puts "== #{Time.now-timestart} end"
    end

    if 1==0
      i=0
      timestart =Time.now
      puts "== #{timestart} update logo_uid in Company"
      imgs = ['2017/03/06/5yxev2hslr_avstraliya_gory_priroda_krasivo_69324_1920x1080.jpg',
              '2017/03/06/79ja1asu2o_Image_114.jpg',
              '2017/03/06/88ttv082n8_Image_101.jpg',
              '2017/03/20/7n0di6qe7l_1920x1080_kartinka_armageddon_7924_7924.jpg',
              '2017/03/20/8plkw3pmhz_Image_102.jpg']
      Company.where('logo_uid ISNULL').find_in_batches.each do |companies|
        companies.each do |company|
          company.logo_uid = imgs[Random.rand(5)]
          company.save
        end
        i+=1
        puts "== #{Time.now-timestart} complete #{i*1000} row"
      end
      puts "== #{Time.now-timestart} end"
    end


    i=0
    timestart =Time.now
    puts "== #{timestart} update birth day"
    Client.where('birth ISNULL').find_in_batches.each do |clients|
      clients.each do |client|
        client.birth = Date.today - Random.rand(365*10)
        client.save
      end
      i+=1
      puts "== #{Time.now-timestart} complete #{i*1000} row"
    end
    puts "== #{Time.now-timestart} end"


    i=0
    timestart =Time.now
    puts "== #{timestart} update location in Resume"
    Resume.where('location_id ISNULL').find_in_batches.each do |resumes|
      resumes.each do |resume|
        resume.location_id = resume.client.location_id
        resume.save
      end
      i+=1
      puts "== #{Time.now-timestart} complete #{i*1000} row"
    end
    puts "== #{Time.now-timestart} end"

    if 1==1
      i=0
      timestart =Time.now
      puts "== #{timestart} Updates clients"
      Client.all.each do |t|
        if t.resp
          t.type ="employer"
        else
          t.type ="applicant"
        end
        t.save
        i+=1
        puts "== #{Time.now-timestart} complete #{i*1000} row"
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

all = Client.count+Company.count+Education.count+Experience.count+Industry.count+Industrycompany.count+Size.count
all +=Industryexperience.count+Industryjob.count+Industryresume.count+Job.count+Languageresume.count+Skillsjob.count
all +=Language.count+Level.count+Location.count+Propert.count+Responsible.count+Resume.count+Skillsresume.count
puts "--==All objects #{all}==--"
puts "== #{Time.now - ttime } end seed"
end




