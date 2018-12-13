require 'open-uri'
require 'nokogiri'
require './app/addon/Proxy'

class Crawler

  def initialize
    @proxy = Proxy.new
    jobs_for_index = Job.includes(:company).where(":yesterday<=jobs.created_at", yesterday: Time.now.beginning_of_day - 1.day)
    @index = jobs_for_index.pluck(:sources)
    @index_full = jobs_for_index.map{|t|t.title + " || " + t.company.name }
    @local = Thread::Queue.new()
    @jobs = Thread::Queue.new()
    @quantity_threads = 11
  end

  def run
    threads = []
    @quantity_threads.times do |i|
      threads << Thread.new do
        if i != @quantity_threads -1
          while local = @local.pop
            if @local.size == 0
              puts "<><>Локации кончились. Закрываем поток<><>"
              @local.close
            end
            get_main_page(local, i)
          end
        else
          while job  = @jobs.pop
            sleep 60 if @jobs.size == 0 and @local.closed?
            @jobs.close if @jobs.size == 0 and @local.closed?
            create_jobs(job)
          end
        end
      end
    end
    threads.each(&:join)
  end

  def get_page(url)
    begin
      Nokogiri::HTML(@proxy.connect(url))
    rescue
      puts ("Ошибка #{$!}")
      nil
    end
  end

  def create_jobs(job)
    Job.automatic_create(job)
  end

  def to_file(text, name)
    puts "Не нашли количества страниц всего сохраняем страницу полностью"
    file = File.new(name,"w")
    file.puts text
    file.close
  end

  def compare_with_index(**arg)
    if @index.include?(arg[:url])
      puts "!!! Нашли ссылку на работу. Уже присутсвует в БД !!!"
      :same_sources
    elsif @index_full.include?(arg[:title] + " || " + arg[:company])
      "!!! Нашли работу по наименованию компании и заглавию #{arg[:title] + " || " + arg[:company]} !!!"
      :same_title_and_company
    else
      false
    end
  end

  def update_attr(attr)
    attr = Nokogiri::HTML(attr)
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

end