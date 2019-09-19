require 'nokogiri'
require "#{Rails.root}/lib/tasks/crawler/path.rb"

class Crawler
  MAX_PAGE = 10
  ST = 'date'
  QUERY_FOR_URL = {
      'tracking'=> :jobsgalore,
      'utm_source'=> :jobsgaloreeu,
      'utm_campaign'=> :jobsgaloreeu,
      'utm_medium'=> :organic
  }

  def initialize
    @connect = ConnectPg.instance.connect
    @proxy = Proxy.new
    @queue_local =  Location.new(@connect).call.inject(Thread::Queue.new, :push)
    @queue_jobs_for_save = Thread::Queue.new()
    @queue_for_prepare_jobs = Thread::Queue.new()
    @queue_tasks_get_jobs = Thread::Queue.new()
    @block_list = []
    @quantity_threads = {conveer_get_list: 4, conveer_prepare_job:1, conveer_get_job: 14, conveer_save_job: 1}
    @count_job = {}

  end

  def run
    #Конвеер 1 | 4 потоков
    @group_a = create_conveer(@quantity_threads[:conveer_get_list]){|i| conveer_get_list(i)}
    #Конвеер 2 | 1 потоков
    @group_b = create_conveer(@quantity_threads[:conveer_prepare_job]){|i| conveer_prepare_job(i)}
    #Конвеер 3 | 14 потоков
    @group_c = create_conveer(@quantity_threads[:conveer_get_job]){|i|conveer_get_job(i)}
    #Конвеер 4 | 1 потоков
    @group_d = create_conveer(@quantity_threads[:conveer_save_job]){|i|conveer_save_job(i)}
    #@threads.each(&:join)
    (@group_a.list + @group_b.list + @group_c.list + @group_d.list).each{|t| t.join(60)}
    puts @count_job
    @connect.close
  end

  def conveer_get_list(i)
    i = "conveer_get_list_#{i}"
    while obj = @queue_local.pop
      get_main_page(obj, i) if obj #and 1==2
      if @queue_local.size == 0
        @queue_local.close
        Thread.current.exit
      end
    end
  end

  def conveer_prepare_job(i)
    i = "conveer_prepare_job_#{i}"
    while true
      if @queue_for_prepare_jobs.size > 0
        obj = @queue_for_prepare_jobs.pop
        get_list(obj, i) if obj
      else
        sleep 2
      end
      if @queue_for_prepare_jobs.size == 0 and @group_a.list.size == 0
        @queue_for_prepare_jobs.close
        Thread.current.exit
      end
    end
  end

  def conveer_get_job(i)
    i = "conveer_get_job_#{i}"
    while true
      if @queue_tasks_get_jobs.size > 0
        obj = @queue_tasks_get_jobs.pop()
        get_job(obj, i) if obj
      else
        sleep 2
      end
      if @queue_tasks_get_jobs.size == 0 and @group_b.list.size == 0
        @queue_tasks_get_jobs.close
        Thread.current.exit
      end
    end
  end

  def conveer_save_job(i)
    i = "conveer_save_job_#{i}"
    while true
      if @queue_jobs_for_save.size >0
        obj = @queue_jobs_for_save.pop
        create_jobs(obj, i) if obj
      else
        sleep 2
      end
      if @queue_jobs_for_save.size == 0 and @group_c.list.size ==0
        @queue_jobs_for_save.close
        Thread.current.exit
      end
    end
  end

  def create_conveer(len = 1)
    threads = ThreadGroup.new
    len.times do |i|
      threads.add(Thread.new{yield(i)})
    end
    threads
  end
  #_______________________________________________________
  #
  #
  def get_main_page(obj, thread)
    end_job = false
    count_page = nil
    iter = nil
    MAX_PAGE.times do |i|
      break if end_job || @block_list.include?(obj[:code])
      query = create_query(obj[:name], i)
      request = get_list_jobs(query, nil, obj[:name], i + 1)
      if request
        if i == 0
          count_ads = count_ads(request)
          break if count_ads.nil? || (count_ads == 0)
          count_page = count_ads / 10
          count_page += 1 if count_ads % 10 > 0
          log(obj[:name], j, i + 1, "Количество страниц всего #{count_page}")
          iter = count_page > MAX_PAGE ? MAX_PAGE : count_page
        end
        @queue_for_prepare_jobs.push(
            {jobs: request.css('div.result, a.result, div.job'),
             location: obj[:code],
             location_name: obj[:name],
             page: i + 1
            }
        )
      end
      break if (i + 1) == iter
    end
  end

  def get_list(list_of_jobs, thread)
    end_job = false
    log(list_of_jobs[:location_name], thread, list_of_jobs[:page], "На странице #{list_of_jobs[:jobs].count} работ")
    end_job = true if list_of_jobs[:jobs].count == 0
    list_of_jobs[:jobs].each do |job|
      title = title(job)
      if title
        if how_long(age_of_job_content(job), thread, list_of_jobs[:location_name], list_of_jobs[:page], title[:title])
          url = url_to_job(title[:href])
          company = company(job)
          log(list_of_jobs[:location_name], list_of_jobs[:page], "title: #{title[:title]} | company: #{company}")
          if company
            compare = compare_with_index(
                url:url,
                title: title[:title],
                company:company,
                location_id: list_of_jobs[:location],
                location: list_of_jobs[:location_name],
                page: list_of_jobs[:page]
            )
            if compare[:flag] == :same_sources
              end_job = true
              @block_list.push(list_of_jobs[:location])
              break
            elsif %i[same_title_and_company block_list].include?(compare[:flag])
              nil
            else
              salary = salary(job)
              @queue_tasks_get_jobs.push({
                link: url,
                title: title[:title],
                company: company,
                company_id: compare[:company_id],
                salary_min: salary.present? ? salary[0] : nil,
                salary_max: salary.present? ? salary[1] : nil,
                location: list_of_jobs[:location],
                location_name: list_of_jobs[:location_name],
                page: list_of_jobs[:page]
                }
              )
            end
          else
            log(list_of_jobs[:location_name], thread,  list_of_jobs[:page], "ВНИМАНИЕ для #{title[:title]} компания пуста")
          end
        else
          log(list_of_jobs[:location_name], thread,  list_of_jobs[:page], "title:#{title[:title]} Работа старая")
        end
      else
        log(list_of_jobs[:location_name], thread,  list_of_jobs[:page], "ERROR: Title is null #{obj[:link]}")
      end
    end
    end_job
  end

  def get_job(obj, thread)
    log(obj[:location_name], thread, obj[:page], "title: #{obj[:title]} работа ---> url: #{obj[:link]}")
    job = get_page(obj[:link])
    apply_link = apply_link(job)
    apply = apply_calculate(obj, apply_link)
    log(obj[:location_name], thread, obj[:page], "title: #{obj[:title]} apply_link #{apply}")
    description = description(job)
    if description
      @queue_jobs_for_save.push(
          link: obj[:link],
          title: obj[:title],
          company: obj[:company],
          company_id: obj[:company_id],
          salary_min: obj[:salary_min],
          salary_max: obj[:salary_max],
          location: obj[:location],
          location_name: obj[:location_name],
          description: html_to_markdown(description),
          apply: apply
      )
    else
      log(obj[:location_name], thread, obj[:page], "title: #{obj[:title]} ERROR description is null #{obj[:link]}")
      nil
    end
  end

  def create_jobs(job, thread)
    begin
      @count_job[job[:location_name]] ? @count_job[job[:location_name]] +=1 : @count_job[job[:location_name]] = 1
      log(job[:location_name], thread, nil, "create job #{job[:link]}")
      Job.automatic_create(job)
    rescue
      log(job[:location_name], thread,nil, "ERROR create job #{job[:link]}")
    end
  end

  #___________________________________________________________

  private

  def get_page(url)
    begin
      Nokogiri::HTML(@proxy.connect(url))
    rescue
      puts ("Ошибка #{$!}")
      nil
    end
  end

  def apply_calculate(obj, apply_link)
    if apply_link && apply_link[:href]
      link = URI(apply_link[:href])
      if link.host.blank?
        url_from_button = @host + apply_link[:href]
      else
        url_from_button = apply_link[:href]
      end
      begin
        resp = JSON.parse(@proxy.redirect(url_from_button), opts={symbolize_names:true})
        if resp
          uri = URI(resp[:uri])
          if  uri.host != URI(@host).host
            #if uri.host
            log(obj[:location_name], obj[:page], "Старый линк = #{uri.to_s}")
            query_from_site  =  Rack::Utils.parse_nested_query(uri.query)
            query_from_site['source'] = 'jobsgaloreeu' if query_from_site['source']
            query_from_site = query_from_site.merge(QUERY_FOR_URL)
            log(obj[:location_name], obj[:page], "query_from_site  = #{query_from_site.to_s} query_from_site.class = #{query_from_site.class}")
            uri.query = query_from_site.to_query
            log(obj[:location_name], obj[:page], "Новый линк = #{uri.to_s}")
            return uri.to_s
          end
        end
      rescue
        log(obj[:location_name], obj[:page], "ERROR #{$!} getting a good url#{url_from_button}")
        nil
      end
      url_from_button
    else
      obj[:link]
    end
  end

  def to_file(text, name)
    puts "Не нашли количества страниц всего сохраняем страницу полностью"
      file = File.new(name,"w")
    file.puts text
    file.close
  end

  def how_long(text, thread, location, page, title)
    log(location, thread, page, "title: #{title} how_long::#{text}")
    if text == "Just posted" or text=~/hour|1 day|minute|Today/ or text.blank?
      true
    else
      false
    end
  end

  def get_list_jobs(arg, thread, location, page)
    url = @url + arg.to_query
    log(location, thread, page, "URL job_list: #{url}")
    get_page(url)
  end

  def compare_with_index(arg)
    result = {flag: false, company_id: nil}
    block_list = []
    block_list.push("Jora Local")
    if block_list.include?(arg[:company])
      log(arg[:location], arg[:thread], arg[:page], "!!! Компания в блок листе !!! #{arg[:company]}")
      return result[:flag]= :block_list
    end

    company_id = Company.new(@connect).call(arg[:company])
    return result unless company_id

    result[:company_id] = company_id
    job = Job.new(@connect).call(
        location:arg[:location_id],
        sources: arg[:url],
        title:arg[:title],
        company: company_id
    )
    return result unless job
    if job[:"sources"] == arg[:url]
      log(arg[:location], arg[:thread], arg[:page], "!!! Нашли ссылку на работу. Уже присутсвует в БД !!! #{arg[:url]} | #{arg[:title]} }")
      return result[:flag]= :same_sources
    end
    if job[:"title"] == arg[:title]
      log(arg[:location], arg[:thread], arg[:page], "!!! Нашли работу по наименованию компании и заглавию #{arg[:title] + " || " + arg[:company]} !!!")
      return result[:flag]= :same_title_and_company
    end
    result
  end

  def update_attr(attr)
    attr.css('*').each do |elem|
      if elem&.count>0 then
        elem.each do |attr, value|
          if attr != 'href'
            elem.remove_attribute(attr)
          else
            href_edit(elem, value)
          end
        end
      end
    end
    attr.to_s
  end

  def href_edit(elem, value)
    value[0] == '/' ? elem[:href] = @host+value : elem[:href] = 'http://'+value
  end

  def gsub_html(arg)
    arg.gsub(/<span>|<\/span>|<div>|<\/div>/,"").gsub(/<h1>|<h2>|<h3>/,"<h4>").gsub(/<\/h1>|<\/h2>|<\/h3>/,"</h4>").squish.gsub("> <","><")
  end

  def html_to_markdown(arg)
    gsub_html(update_attr(arg))
  end

  def log(location = nil, thread = nil, page = nil, message = nil)
    puts "#{Time.now} | location = #{location}, thread = #{thread}, page = #{page}, message = #{message}"
  end

end