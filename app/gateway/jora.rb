require 'open-uri'
require 'nokogiri'
require './app/addon/Proxy'

class Jora < Adapter
  SP = "facet_listed_date"
  MAX_PAGE = 10
  ST = "date"


  def initialize(arg)
    @proxy = Proxy.new
    @host = 'https://au.jora.com'
    @url = 'https://au.jora.com/j?'
    @local = Thread::Queue.new()
    query = ['suburb in (\'Melbourne\',\'Brisbane\', \'Sydney\')',
             'suburb in (\'Liverpool\',\'Penrith\', \'Logan City\', \'Dandenong\', \'Parramatta\', \'Melton\', \'Adelaide\', \'Port Adelaide\', \'Ipswich\', \'Kensington\', \'Caboolture\', \'Redland City\', \'Frankston\', \'Mount Barker\', \'Canberra\', \'Perth\', \'Fremantle\', \'Newcastle\')',
             'suburb not in (\'Melbourne\',\'Brisbane\', \'Sydney\', \'Liverpool\',\'Penrith\', \'Logan City\', \'Dandenong\', \'Parramatta\', \'Melton\', \'Adelaide\', \'Port Adelaide\', \'Ipswich\', \'Kensington\', \'Caboolture\', \'Redland City\', \'Frankston\', \'Mount Barker\', \'Canberra\', \'Perth\', \'Fremantle\', \'Newcastle\')']
    location = Location.select(:id, :suburb, :state).where(query[arg - 1])
    location.map{|city| @local << {name:city.suburb,code:city.id}}
    @index = Job.select(:sources).where(":yesterday<=created_at and sources like :host and location_id in (:lids)", yesterday: arg == 3 ? Time.now.beginning_of_day - 2.day : Time.now.beginning_of_day - 1.day, host:@host+'%', lids:location.ids).pluck(:sources)
    @jobs = Thread::Queue.new()
  end


  def get_list_jobs
    threads = []
    count_treads = @local.size == 3 ? 3 :10
    count_treads.times do |i|
      threads << Thread.new do
        if i != count_treads
          while local = @local.pop
            @local.close if @local.size == 0
            t = Time.now
            get_location(local, i)
          end
        else
          while job  = @jobs.pop
            if @jobs.size == 0 and @local.closed?
              sleep 90
              @jobs.close
            end
            create_jobs(job)
          end
        end
      end
    end
    threads.each(&:join)
  end

  def get_location(local, j)
    end_job = false
    MAX_PAGE.times do |i|
      break if end_job
      query = {a: '24h',button:nil, l: local[:name], p: i,  sp: SP, st:ST}
      puts "Поток #{j} query = #{query}"
      request = get_page(query)
      count_ads =  request&.css('body div[id="main"] div[id="centre_col"] div[id="search_info"] span')&.last&.text&.delete(',').to_i
      break if count_ads.nil? or count_ads==0
      count_page = count_ads / 10
      count_page +=1 if (count_ads % 10 > 0)
      iter  = count_page > MAX_PAGE ? MAX_PAGE : count_page
      end_job = get_list(request, local[:code], j)
      break if (i + 1 ) == iter
    end
  end

  def get_list(arg, lacation, j)
    end_job = false
    arg.css('div[id="main"] div[id="centre_col"] ul[id="jobresults"] div[class="job"]').each do |job|
      title = job.at_css('a[class="jobtitle"]')
      title ||=   job.at_css('a[class="job"]')
      url = @host + title[:href][0..title[:href].index('?') - 1]
      if @index.include?(url)
        end_job = true
        break
      end
      salary = job.at_css('div div[class="salary"]')&.text&.gsub(',','')&.scan(/\d+/)
      company = job.at_css('div span[class="company"]')&.text
      if company
        job = get_job(url, j)
        if job
          @jobs<<{link: url,
                      title: title[:title],
                      company: company,
                      salary_min: salary.present? ? salary[0] : nil,
                      salary_max: salary.present? ? salary[1] : nil,
                      location: lacation,
                      apply: job[:apply],
                      description: job[:description]}
        end
      end
    end
    end_job
  end

  def get_page(arg)
    begin
      arg[:p] +=1
      arg.delete(:p) if arg[:p] == 1
      url = @url+arg.to_query
      puts "URL job list = #{url}"
      Nokogiri::HTML(@proxy.connect(url))
    rescue
      puts ("Ошибка #{$!}")
      nil
    end
  end

  def get_job(url, j)
    begin
      job = Nokogiri::HTML(@proxy.connect(url))
      apply_link = job.at_css('a[class="button apply_link"]')
      apply = apply_link ? @host +apply_link[:href] : url
     {description: html_to_markdown(job.at_css('div[class="summary"]').children.to_s), apply:apply}
    rescue
      puts ("Поток #{j} Ошибка #{ $!} #{job}")
      nil
    end
  end

  def create_jobs(job)
    old_company = true
    company = Company.find_or_create_by(name: job[:company]) do |comp|
      comp.name = job[:company]
      comp.size = Size.first
      comp.location_id = job[:location]
      comp.industry_id = job[:industry]
      old_company = false
    end
    company.job.where(title: job[:title], location_id: job[:location]).destroy_all if old_company
    user = company.client.first
    if user.blank?
      email = "#{job[:company].gsub(' ', '_')}#{(0...8).map {(97 + rand(25)).chr}.join}@email.com.au"
      user = Client.new(firstname: job[:company], lastname: 'HR', email: email, location_id: job[:location], character: TypeOfClient::EMPLOYER, send_email: false, password: '11111111', password_confirmation: '11111111', company_id: company.id)
      user.skip_confirmation! if Rails.env.production?
      user.save!
    end
    Job.create!(title: job[:title],
                location_id: job[:location],
                salarymin: job[:salary_min],
                salarymax: job[:salary_max],
                description: job[:description],
                company: company,
                client: user,
                sources: job[:link],
                apply: job[:apply])
  end
end