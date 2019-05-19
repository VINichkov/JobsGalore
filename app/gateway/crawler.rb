require 'nokogiri'
require './app/addon/Proxy'

class Crawler

  def initialize
    @proxy = Proxy.new
    @queue_local = Thread::Queue.new()
    Location.select(:id, :suburb, :state).all.each{|city| @queue_local << {name:city.suburb,code:city.id}}
    @queue_jobs_for_save = Thread::Queue.new()
    @queue_for_prepare_jobs = Thread::Queue.new()
    @queue_tasks_get_jobs = Thread::Queue.new()
    @block_list = []
    @quantity_threads = {conveer_get_list: 4, conveer_prepare_job:1, conveer_get_job: 14, conveer_save_job: 1}
    @count_job = {}
  end

  def run
    #Конвеер 1 | 10 потоков
    @group_a = create_conveer(@quantity_threads[:conveer_get_list]){|i| conveer_get_list(i)}
    #Конвеер 2 | 1 потоков
    @group_b = create_conveer(@quantity_threads[:conveer_prepare_job]){|i| conveer_prepare_job(i)}
    #Конвеер 3 | 10 потоков
    @group_c = create_conveer(@quantity_threads[:conveer_get_job]){|i|conveer_get_job(i)}
    #Конвеер 4 | 1 потоков
    @group_d = create_conveer(@quantity_threads[:conveer_save_job]){|i|conveer_save_job(i)}
    #@threads.each(&:join)
    (@group_a.list + @group_b.list + @group_c.list + @group_d.list).each{|t| t.join(60)}
    puts @count_job
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

  def get_page(url)
    begin
      Nokogiri::HTML(@proxy.connect(url))
    rescue
      puts ("Ошибка #{$!}")
      nil
    end
  end

  def create_jobs(job, thread)
    @count_job[job[:location_name]] ? @count_job[job[:location_name]] +=1 : @count_job[job[:location_name]] = 1
    log(job[:location_name], thread, nil, "create job #{job[:link]}")
    Job.automatic_create(job)
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
    block_list = []
    block_list.push("Jora Local")
    if block_list.include?(arg[:title])
      log(arg[:location], arg[:thread], arg[:page], "!!! Компания в блок листе !!! #{arg[:title]}")
      :block_list
    elsif Job.where(location_id: arg[:location_id],  sources:arg[:url]).first
      log(arg[:location], arg[:thread], arg[:page], "!!! Нашли ссылку на работу. Уже присутсвует в БД !!! #{arg[:url]} | #{arg[:title]} }")
      :same_sources
    elsif Job.where(title: arg[:title], company_id: Company.find_by_names_or_name(arg[:company]), location_id: arg[:location_id]).first
      log(arg[:location], arg[:thread], arg[:page], "!!! Нашли работу по наименованию компании и заглавию #{arg[:title] + " || " + arg[:company]} !!!")
      :same_title_and_company
    else
      false
    end
  end

  def update_attr(attr)
    attr.css('*').each do |elem|
      if elem&.count>0 then
        elem.each do |attr, value|
          if attr != 'href'
            elem.remove_attribute(attr)
          else
            href_edit(elem, attr, value)
          end
        end
      end
    end
    attr.to_s
  end

  def href_edit(elem, attr, value)
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