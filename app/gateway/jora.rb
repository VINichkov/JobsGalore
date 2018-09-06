require 'open-uri'
require 'nokogiri'
class Jora < Adapter
  INDUSTRY = [{code:Industry.find_by_name("Banking & Finance").id,text:'cat:banking-financial-services'},
              {code:Industry.find_by_name("IT").id,text:'cat:information-communication-technology'},
              {code:Industry.find_by_name("Engineering").id, text:'cat:engineering'},
              {code:Industry.find_by_name("Sales").id, text:'cat:sales'},
              {code:Industry.find_by_name("Health, Medical & Pharmaceutical").id, text:'cat:healthcare-medical'},
              {code:Industry.find_by_name("Construction, Architecture & Interior Design").id, text:'cat:construction'},
              {code:Industry.find_by_name("Accounting").id, text:'cat:accounting'},
              {code:Industry.find_by_name("Administration & Secretarial").id, text:'cat:administration-office-support'},
              {code:Industry.find_by_name("Trades & Services").id, text:'cat:trades-services'},
              {code:Industry.find_by_name("Marketing").id, text:'cat:marketing-communications'},
              {code:Industry.find_by_name("HR & Recruitment").id, text:'cat:human-resources-recruitment'},
              {code:Industry.find_by_name("Education, Childcare & Training").id, text:'cat:education-training'},
              {code:Industry.find_by_name("Manufacturing & Industrial").id, text:'cat:manufacturing-transport-logistics'},
              {code:Industry.find_by_name("Administration & Secretarial").id, text:'cat:community-services-development'},
              {code:Industry.find_by_name("Administration & Secretarial").id, text:'cat:consulting-strategy'},
              {code:Industry.find_by_name("Property & Real Estate").id, text:'cat:real-estate-property'},
              {code:Industry.find_by_name("Mining, Oil & Gas").id, text:'cat:mining-resources-energy'},
              {code:Industry.find_by_name("Customer Service & Call Centre").id, text:'cat:call-centre-customer-service'},
              {code:Industry.find_by_name("Retail").id, text:'cat:retail-consumer-products'},
              {code:Industry.find_by_name("Construction, Architecture & Interior Design").id, text:'cat:design-architecture'},]
  SP = "facet_location"
  #SA = 110000
  LOCAL = [{name:'Melbourne VIC',code:Location.find_by_suburb("Melbourne").id},
           {name:'Brisbane QLD',code:Location.find_by_suburb("Brisbane").id},
           {name:'Sydney NSW',code:Location.find_by_suburb("Sydney").id}]
  SURL = 0
  MAX_JOBS = 290

  def initialize
    @params = [1].map do|i|
      INDUSTRY.map do |industry|
        LOCAL.map do |local|
          {query:{a:'24h', l:local[:name], p:i, q:industry[:text],sp:SP,surl:SURL}.to_query,
           location:local[:code],
           industry:industry[:code]}
        end
      end
    end.flatten
    @host = 'http://au.jora.com'
    @url = 'http://au.jora.com/j?'
  end

  def get_list_jobs
    @jobs = @params.map do |params|
       Nokogiri::HTML(open(@url+params[:query], {"User-Agent"=>'Googlebot 2.1'})).css('[id="jobresults"] [class="job"]').map do |job|
         salary = job.at_css('div div[class="salary"]')&.text&.gsub(',','')&.scan(/\d+/)
         if salary
           title = job.at_css('a[class="jobtitle"]')
           url = @host + title[:href][0..title[:href].index('?')-1]
           unless Job.find_by_sources(url)
             company = job.at_css('div span[class="company"]')&.text
             if company
              job = get_job(url)
              if job
                {link: url, title:title[:title], company: company, salary_min: salary[0],salary_max:salary[1], location:params[:location], industry:params[:industry], apply:job[:apply], description:job[:description] }
              else
                nil
              end
             end
           end
         end
      end
    end.flatten.compact
  end

  def get_job(url)
    begin
      job = Nokogiri::HTML(open(url, {"User-Agent"=>'Googlebot 2.1'})).at_css('div[id="vj_container"]')
      {description: html_to_markdown(job.at_css('div[class="summary"]').children.to_s), apply:@host + job.at_css('a[class="button apply_link"]')[:href]}
    rescue StandardError=>e
      Rails.logger.debug("Ошибка #{e.to_s}")
      nil
    end
  end

  def create_jobs(arg)
    if arg.class == Array
      puts "Получили #{arg.count} записей"
      arg.each do |job|
        company = Company.find_or_create_by(name: job[:company]) do |comp|
          puts "Не нашли компанию #{job[:company]}. Создаем новую"
          comp.name = job[:company]
          comp.size = Size.first
          comp.location_id = job[:location]
          comp.industry_id = job[:industry]
        end
        user = company.client.first
        if user.blank?
          puts "Компания новая. Создаем клиента #{"#{job[:company].gsub(' ','_')}@email.com.au"}"
          user = Client.new(firstname:job[:company], lastname:'HR', email:"#{job[:company].gsub(' ','_')}@email.com.au",location_id:job[:location], character:TypeOfClient::EMPLOYER, send_email:false, password:'11111111', password_confirmation:'11111111', company_id: company.id)
          user.skip_confirmation!
          user.save
        end
        Job.create!(title:job[:title],
                    location_id:job[:location],
                    salarymin:job[:salary_min],
                    salarymax:job[:salary_max],
                    description: job[:description],
                    company: company,
                    client: user,
                    sources: job[:link],
                    industry_id: job[:industry],
                    apply: job[:apply])
      end
    end
  end
end