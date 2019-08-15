require 'nokogiri'

class Crawler
  MAX_PAGE = 10
  ST = 'date'

  def initialize
    @proxy = Proxy.new
    @query_for_url = { tracking: :jobsgalore, utm_source: :jobsgaloreeu, utm_campaign: :jobsgaloreeu, utm_medium: :organic }
  end

  def get_main_page(obj, variable)
    end_job = false
    count_page = nil
    iter = nil
    MAX_PAGE.times do |i|
      break if end_job || var(variable).nil? ||var(variable)&.include?(obj[:code])
      query = create_query(obj[:name], i)
      request = get_list_jobs(query, obj[:name], i + 1)
      if request
        if i == 0
          count_ads = count_ads(request)
          break if count_ads.nil? || (count_ads == 0)
          count_page = count_ads / 10
          count_page += 1 if count_ads % 10 > 0
          iter = count_page > MAX_PAGE ? MAX_PAGE : count_page
        end
        ConveerPrepareJob.perform_later(
            {jobs: request.to_s,
            location: obj[:code],
            location_name: obj[:name],
            page: i + 1,
            site: obj[:site],
            var: obj[:var]})
      end
      break if (i + 1) == iter
    end
  end

  def get_list(list_of_jobs, variable)
    #Десериализация
    list_of_jobs[:jobs] =  Nokogiri::HTML(list_of_jobs[:jobs]).css('div.result, a.result, div.job')
    #
    end_job = false
    log(list_of_jobs[:location_name],  list_of_jobs[:page], "На странице #{list_of_jobs[:jobs].count} работ")
    end_job = true if list_of_jobs[:jobs].count == 0
    list_of_jobs[:jobs].each do |job|
      title = title(job)
      if how_long(age_of_job_content(job),  list_of_jobs[:location_name], list_of_jobs[:page], title[:title])
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
          if compare == :same_sources
            end_job = true
            var_push(variable, list_of_jobs[:location])
            break
          elsif %i[same_title_and_company block_list].include?(compare)
            nil
          else
            salary = salary(job)
            ConveerGetJob.perform_later({link: url,
                                        title: title[:title],
                                        company: company,
                                        salary_min: salary.present? ? salary[0] : nil,
                                        salary_max: salary.present? ? salary[1] : nil,
                                        location: list_of_jobs[:location],
                                        location_name: list_of_jobs[:location_name],
                                        page: list_of_jobs[:page],
                                        site: list_of_jobs[:site],
                                        var: list_of_jobs[:var]})
          end
        else
          log(list_of_jobs[:location_name],  list_of_jobs[:page], "ВНИМАНИЕ для #{title[:title]} компания пуста")
        end
      else
        log(list_of_jobs[:location_name],  list_of_jobs[:page], "title:#{title[:title]} Работа старая")
      end
    end
    end_job
  end

  def get_job(obj)
    log(obj[:location_name], obj[:page], "title: #{obj[:title]} работа ---> url: #{obj[:link]}")
    job = get_page(obj[:link])
    apply_link = apply_link(job)
    apply = apply_calculate(obj, apply_link)
    log(obj[:location_name], obj[:page], "title: #{obj[:title]} apply_link #{apply}")
    description = description(job)
    if description
      ConveerSaveJob.perform_later(
          link: obj[:link],
          title: obj[:title],
          company: obj[:company],
          salary_min: obj[:salary_min],
          salary_max: obj[:salary_max],
          location: obj[:location],
          location_name: obj[:location_name],
          description: html_to_markdown(description),
          apply: apply,
          site: obj[:site]
      )
    else
      log(obj[:location_name], obj[:page], "title: #{obj[:title]} ERROR description is null #{obj[:link]}")
      nil
    end
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
    begin
      log(job[:location_name], nil, "create job #{job[:link]}")
      Job.automatic_create(job)
    rescue
      log(job[:location_name], nil, "ERROR create job #{job[:link]}")
    end

  end

  def get_list_jobs(arg, location, page)
    url = @url + arg.to_query
    get_page(url)
  end

  #private

  def to_file(text, name)
    puts "Не нашли количества страниц всего сохраняем страницу полностью"
    file = File.new(name,"w")
    file.puts text
    file.close
  end

  def how_long(text, location, page, title)
    log(location,  page, "title: #{title} how_long::#{text}")
    if text == "Just posted" or text=~/hour|1 day|minute|Today/ or text.blank?
      true
    else
      false
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
            query_from_site = query_from_site.merge(@query_for_url.stringify_keys)
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

  def compare_with_index(arg)
    block_list = []
    block_list.push("Jora Local")
    if block_list.include?(arg[:company])
      log(arg[:location],  arg[:page], "!!! Компания в блок листе !!! #{arg[:company]}")
      :block_list
    elsif Job.where(location_id: arg[:location_id],  sources:arg[:url]).first
      log(arg[:location],  arg[:page], "!!! Нашли ссылку на работу. Уже присутсвует в БД !!! #{arg[:url]} | #{arg[:title]} }")
      :same_sources
    elsif Job.where(title: arg[:title], company_id: Company.find_by_names_or_name(arg[:company]), location_id: arg[:location_id]).first
      log(arg[:location],  arg[:page], "!!! Нашли работу по наименованию компании и заглавию #{arg[:title] + " || " + arg[:company]} !!!")
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

  def log(location = nil, page = nil, message = nil)
    if ENV['RAILS_ENV']=='development'
      puts "#{Time.now} | location = #{location}, page = #{page}, message = #{message}"
    end
  end

  def var(id)
    Variable.find_by_id(id)&.value
  end

  def var_push(id, val)
    variable =  Variable.find_by_id(id)
    variable.value.push(val)
    variable.save
  end

end