require 'open-uri'
require 'nokogiri'
require './app/addon/Proxy'
class Jora < Adapter
  SP = "facet_location"
  LOCAL = Location.select(:id, :suburb, :state).all.map{|city| {name:city.suburb + ' '+ city.state,code:city.id}}
  MAX_PAGE = 1

  def initialize
    @proxy = Proxy.new
    @host = 'https://au.jora.com'
    @url = 'https://au.jora.com/j?'
  end

  def get_list_jobs
    @time_db = 0
    @time_db2 = 0
    @time_hokogiri = 0
    @time_create = 0
    @time_download = 0
    @time_download2 = 0
    @count_all = 1
    w = Time.now
    LOCAL.map do |local|
      MAX_PAGE.times do |i|
          t= Time.now
          query = {a: '24h', l: local[:name], p: i,  sp: SP}
          request = get_page(query)
          t = Time.now - t
          puts "--- Запрос новой локации #{t}"
          @time_download += t
          t= Time.now
          count_ads =  request&.css('body div[id="main"] div[id="centre_col"] div[id="search_info"] span')&.last.text.delete(',').to_i
          break if count_ads.nil?
          count_page = count_ads / 10
          count_page +=1 if (count_ads % 10 > 0)
          iter  = count_page > MAX_PAGE ? MAX_PAGE : count_page
          get_list(request, local[:code])
          @time_hokogiri += Time.now - t
          break if (i + 1 ) == iter
        end
    end
    puts "Time db = #{@time_db + @time_db2} s"
    puts "Time db 1 = #{@time_db} s"
    puts "Time db 2 = #{@time_db2} s"
    puts "Time hokogiri = #{@time_hokogiri - @time_create - @time_download2} s"
    puts "Time create = #{@time_create} s"
    puts "Time download = #{@time_download + @time_download2} s"
    puts "Time download 1 = #{@time_download } s"
    puts "Time download 2 = #{@time_download2} s"
    puts "Count all = #{@count_all}"
    puts "All Time = #{Time.now - w}"
  end

  private

  def get_page(arg)
    begin
      arg[:p] +=1
      arg.delete(:p) if arg[:p] == 1
      url = @url+arg.to_query
      Nokogiri::HTML(@proxy.connect(url))
    rescue
      puts ("Ошибка #{$!}")
      nil
    end
  end


  def get_list(arg, lacation)
    arg.css('[id="jobresults"] [class="job"]').each do |job|
      t = Time.now
      url = @host + title[:href][0..title[:href].index('?') - 1]
      flag = Job.find_by_sources(url)
      @time_db += Time.now - t
      unless flag
        company = job.at_css('div span[class="company"]')&.text
        if company
          job = get_job(url)
          if job
            salary = job.at_css('div div[class="salary"]')&.text&.gsub(',','')&.scan(/\d+/)
            title = job.at_css('a[class="jobtitle"]')
            create_jobs(link: url,
                        title: title[:title],
                        company: company,
                        salary_min: salary.present? ? salary[0] : nil,
                        salary_max: salary.present? ? salary[1] : nil,
                        location: lacation,
                        apply: job[:apply],
                        description: job[:description])
          else
            nil
          end
        end
      end
    end
  end

  def get_job(url)
    begin
      t = Time.now
      @count_all +=1
      job = Nokogiri::HTML(@proxy.connect(url)).at_css('div[id="vj_container"]')
      apply_link = job.at_css('a[class="button apply_link"]')
      apply = apply_link ? @host +apply_link[:href] : url
      a = {description: html_to_markdown(job.at_css('div[class="summary"]').children.to_s), apply:apply}
      @time_download2 += Time.now - t
      a
    rescue
      puts ("Ошибка #{ $!}")
      nil
    end
  end

  def create_jobs(arg)
    t = Time.now
    job= arg
    old_company = true
    company = Company.find_or_create_by(name: job[:company]) do |comp|
      puts "Не нашли компанию #{job[:company]}. Создаем новую"
      comp.name = job[:company]
      comp.size = Size.first
      comp.location_id = job[:location]
      comp.industry_id = job[:industry]
      old_company = false
    end
    if old_company
      e = Time.now
      company.job.where(title:job[:title], location_id: job[:location]).destroy_all
      @time_db2 += Time.now - e
    end
    user = company.client.first
    if user.blank?
      email = "#{job[:company].gsub(' ', '_')}#{(0...8).map { (97 + rand(26)).chr }.join}@email.com.au"
      user = Client.new(firstname: job[:company], lastname: 'HR', email:email , location_id: job[:location], character: TypeOfClient::EMPLOYER, send_email: false, password: '11111111', password_confirmation: '11111111', company_id: company.id)
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
    @time_create += Time.now - t
  end

end