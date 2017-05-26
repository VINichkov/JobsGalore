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
            index[:pass] = BCrypt::Password.create('11111111')
          when "Industry"
            index[:level]={min:Level.ids.min, count:Level.count}
        end
        eval "#{name}.destroy_all"
        puts "== #{Time.now-timestart} end"
        timestart =Time.now
        puts "== #{timestart} data recording"
        i=0
        import_record = []
        time_start = Time.now
        array.each do |elem|
          if  name =="Company"
            elem[:location_id]=index[:location].sample
            elem[:size_id]=index[:size].sample
          elsif name=="Client"
            elem[:location_id]=index[:location].sample
            elem[:password] = index[:pass]
            elem[:encrypted_password]= index[:pass]
          end
          arg = "import_record << #{name}.new(#{elem.to_s})"
          eval arg
          i+=1
          if i%1000==0
            eval"#{name}.import import_record"
            import_record=[]
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
    index= {location: {min: Location.ids.min, count: Location.count}}
    index[:industry] = {min: Industry.ids.min, count: Industry.count, max:Industry.ids.max}
    index[:company] = {min: Company.ids.min, count:Company.count}

    #Назначение отверственных по команиям
    if Responsible.count==0
      timestart =Time.now
      i=0
      puts "== #{timestart} Linking customers to the company"
      count_client = Client.count
      min_id_client = Client.ids.min
      Company.all.each do |company|
        client=Client.find_by_id(min_id_client+Random.rand(count_client))
        Responsible.create(company: company, client:client)
        client.resp = true
      end
      puts "== #{Time.now-timestart} end"
    end
    #Конец


    #Присвоение индустрий компаниям
    if Industrycompany.count==0
      timestart =Time.now
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
      i=0
      Company.all.each do |company|
        if [false, true].sample
          Random.rand(51).times do

            #Расчет параметров для каждой вакансии
            title = ""
            Random.rand(15).times do
              title+=arr_word[Random.rand(arr_word.size)].delete("\n")+' '
            end
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
            Random.rand(100).times do
              description += arr_word[Random.rand(arr_word.size)].delete("\n")+' '
            end

            #Создаем вакансию
            job = company.job.create(title:title,
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
            index_now  =index[:industry][:min]+Random.rand(index[:industry][:count])
            Random.rand(4).times do
              if index_now>index[:industry][:max]
                index_now = index[:industry][:min]
              end
              industry=job.industryjob.create(industry: Industry.find_by_id(index_now))
              industry.save
              index_now +=1
            end

          end
        end
        i+=1
        puts "== #{Time.now-timestart} complete #{i} row" if (i%1000==0)
      end
      puts "== #{Time.now-timestart} end"
    end

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
      Client.where("responsible = false").find_in_batches.each do |clients|
        resumes=[]
        clients.each do |client|
          if [true, false].sample
            Random.rand(3).times
              #Расчет параметров для каждой вакансии
              desiredjobtitle = ""
              (Random.rand(5)+1).times do
                desiredjobtitle+=arr_word[Random.rand(arr_word.size)].delete("\n")+' '
              end
              salary = (Random.rand(180)+1)*1000
              permanent = [false,true].sample
              casual = [false,true].sample
              temp = [false,true].sample
              contract = [false,true].sample
              fulltime = [false,true].sample
              parttime = [false,true].sample
              flextime = [false,true].sample
              remote = [false,true].sample
              abouteme=""
              (Random.rand(50)+1).times do
                abouteme+=arr_word[Random.rand(arr_word.size)].delete("\n")+' '
              end

              resumes << Resume.new(client:client,
                                  desiredjobtitle:desiredjobtitle,
                                  salary:salary,
                                  permanent:permanent,
                                  casual: casual,
                                  temp:temp,
                                  contract:contract,
                                  fulltime:fulltime,
                                  parttime:parttime,
                                  flextime:flextime,
                                  remote:remote,
                                  abouteme:abouteme)
            end
        end
        Resume.import resumes
        i+=1
        puts "== #{Time.now-timestart} complete #{i*1000} row"
      end
      puts "== #{Time.now-timestart} end"

      #Добавляем индустрии к резюме
      i=0
      timestart =Time.now
      puts "== #{timestart} match the resumes and industries"
      Resume.find_in_batches.each do |resumes|
        industries=[]
        resumes.each do |resume|
            index_now  =index[:industry][:min]+Random.rand(index[:industry][:count])
            Random.rand(2).times do
              if index_now>index[:industry][:max]
                index_now = index[:industry][:min]
              end
              industries << Industryresume.new(resume:resume,industry: Industry.find_by_id(index_now))
              index_now +=1
            end
        end
        i+=1
        Industryresume.import industries
        puts "== #{Time.now-timestart} complete #{i*1000} row"
      end
      puts "== #{Time.now-timestart} end"

      #Добавление опыта работы
      i=0
      timestart =Time.now
      puts "== #{timestart} add experiences"
      Resume.find_in_batches.each do |resumes|
        experiences = []
        resumes.each do |resume|
          count_job= Random.rand(20)+1
          count_job.times do |i|
            #рассчитываем параметры для опыта
            employer = Company.find_by_id(index[:company][:min]+Random.rand(index[:company][:count])).name
            location = Location.find_by_id(index[:location][:min] + Random.rand(index[:location][:count]))
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

      #Связка индустрии и опыта
      i=0
      timestart =Time.now
      puts "== #{timestart} match industries and experiences"
      Experience.find_in_batches.each do |experiences|
        industryexperiences=[]
        experiences.each do |experience|
          industryexperiences<< Industryexperience.new(experience:experience, industry: Industry.find_by_id(index[:industry][:min]+Random.rand(index[:industry][:count])))
        end
        Industryexperience.import industryexperiences
        i+=1
        puts "== #{Time.now-timestart} complete #{i*1000} row"
      end
      puts "== #{Time.now-timestart} end"

    end

    #Задаем пароль тестовым пользователям. У всех 11111111
    i=0
    timestart =Time.now
    puts "== #{timestart} update password on \"11111111\""
    Client.where('encrypted_password ISNULL').find_in_batches.each do |clients|
      clients.each do |client|
        client.encrypted_password= BCrypt::Password.create('11111111')
        client.save
      end
      i+=1
      puts "== #{Time.now-timestart} complete #{i*1000} row"
    end
    puts "== #{Time.now-timestart} end"

    #Предбразуем справочник локаций в целевой вид
    i=0
    timestart =Time.now
    puts "== #{timestart} Linking Locations"
    Location.where('parent_id ISNULL').find_in_batches.each do |locations|
      locations.each do |client|

      end
      i+=1
      puts "== #{Time.now-timestart} complete #{i*1000} row"
    end
    puts "== #{Time.now-timestart} end"

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

rescue
  puts "Error: #{$!}"
end

puts "== #{Time.now - ttime } end seed"
end




