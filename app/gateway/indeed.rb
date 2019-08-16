class Indeed < Crawler

  def initialize
    super
    @host = 'https://au.indeed.com'
    @url = 'https://au.indeed.com/jobs?'
    #@local << {name:'Sydney',code:9522}
  end

=begin
  def get_main_page(obj, thread)
    end_job = false
    count_page = nil
    iter = nil
    MAX_PAGE.times do |i|
      break if end_job or @block_list.include?(obj[:code])
      query = {q:nil, l: obj[:name],sort: ST, start: i}
      log(obj[:name], j, i+1, "Начало")
      request = get_list_jobs(query, thread, obj[:name], i+1)
      if request
        if i==0
          count_ads =  request.css('div#searchCount')&.text&.delete(',').scan(/\d+/).last.to_i
          if count_ads.nil? or count_ads==0
            break
          end
          count_page = count_ads / 10
          count_page +=1 if (count_ads % 10 > 0)
          log(obj[:name], j, i+1, "Количество страниц всего #{count_page}")
          iter  = count_page > MAX_PAGE ? MAX_PAGE : count_page
        end
        @queue_for_prepare_jobs.push({jobs: request.css('div.result, a.result'),
                                      location: obj[:code],
                                      location_name: obj[:name],
                                      page: i+1})
      end
      break if (i + 1 ) == iter
    end
  end

  def get_list(list_of_jobs, thread)
    end_job = false
    log(list_of_jobs[:location_name], thread, list_of_jobs[:page], "На странице #{list_of_jobs[:jobs].count} работ")
    end_job = true if list_of_jobs[:jobs].count == 0
    list_of_jobs[:jobs].each do |job|
      title = job.at_css('a.turnstileLink')
      if how_long(job.at_css('div.result-link-bar span.date')&.text, thread, list_of_jobs[:location_name], list_of_jobs[:page], title[:title])
        url = url_to_job(title[:href])
        company = job.at_css('span.company')&.text&.squish
        if company
          compare = compare_with_index(url:url, title: title[:title], company:company, location_id: list_of_jobs[:location], thread: thread, location: list_of_jobs[:location_name], page: list_of_jobs[:page])
          if compare == :same_sources
            end_job = true
            @block_list.push(list_of_jobs[:location])
            break
          elsif compare==:same_title_and_company
            nil
          else
            salary = job.at_css('div.salary')&.text&.gsub(',','')&.scan(/\d+/)
            @queue_tasks_get_jobs.push({link: url,
                                        title: title[:title],
                                        company: company,
                                        salary_min: salary.present? ? salary[0] : nil,
                                        salary_max: salary.present? ? salary[1] : nil,
                                        location: list_of_jobs[:location],
                                        location_name: list_of_jobs[:location_name],
                                        page: list_of_jobs[:page]})
          end
        else
          log(list_of_jobs[:location_name], thread, list_of_jobs[:page], "ВНИМАНИЕ для #{title[:title]} компания пуста")
        end
      else
        log(list_of_jobs[:location_name], thread, list_of_jobs[:page], "title:#{title[:title]} Работа старая")
      end
    end
    end_job
  end

  def url_to_job(url)
    url=~(/^\/company/) ? @host + url : @host + "/viewjob"+url[url.index('?')..url.length-1]
  end

  def get_list_jobs(arg, thread, location, page)
      arg[:start] != 0 ? arg[:start] *= 10 : arg.delete(:start)
      super
  end

  def get_job(obj, thread)
      log(obj[:location_name], thread, obj[:page], "title: #{obj[:title]} работа ---> url: #{obj[:link]}")
      job = get_page(obj[:link])
      apply_link = job&.css('div#viewJobButtonLinkContainer a, div#jobsearch-ViewJobButtons-container a')&.first
      apply = apply_link ? apply_link[:href] : obj[:link]
      log(obj[:location_name], thread, obj[:page], "title: #{obj[:title]} apply_link #{apply}")
      description = job&.at_css('div.jobsearch-JobComponent-description')&.children
      if description
          @queue_jobs_for_save.push({link: obj[:link],
                                     title: obj[:title],
                                     company: obj[:company],
                                     salary_min: obj[:salary_min],
                                     salary_max: obj[:salary_max],
                                     location: obj[:location],
                                     location_name: obj[:location_name],
                                     description:html_to_markdown(description),
                                     apply:  apply})
      else
        log(obj[:location_name], thread, obj[:page], "title: #{obj[:title]} ERROR description is null #{obj[:link]}")
        nil
      end
  end
=end

  private

  def description(job)
    job&.at_css('div.jobsearch-JobComponent-description')&.children
  end


  def apply_link(job)
    job&.css('div#viewJobButtonLinkContainer a, div#jobsearch-ViewJobButtons-container a')&.first
  end

  def salary(job)
    job.at_css('div.salary')&.text&.gsub(',','')&.scan(/\d+/)
  end

  def company(job)
    job.at_css('span.company')&.text&.squish
  end

  def url_to_job(url)
    url=~(/^\/company/) ? @host + url : @host + "/viewjob"+url[url.index('?')..url.length-1]
  end

  def age_of_job_content(job)
    job.at_css('div.result-link-bar span.date')&.text
  end

  def title(job)
    teg = job.at_css('a.turnstileLink')
    {href: teg[:href], title: teg&.text.squish}
  end

  def create_query(name, i)
    {l: name, sort: ST, start: i, q:nil}
  end

  def count_ads(arg)
    arg.css('div#searchCount')&.text&.delete(',').scan(/\d+/).last.to_i
  end


end