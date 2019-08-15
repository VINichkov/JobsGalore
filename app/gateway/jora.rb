# frozen_string_literal: true

class Jora< Crawler
  SP = 'facet_listed_date'
  MAX_PAGE = 10
  ST = 'date'

  def initialize
    super
    @host = 'https://au.jora.com'
    @url = 'https://au.jora.com/j?'
  end

  def get_main_page(obj, thread)
    end_job = false
    count_page = nil
    iter = nil
    MAX_PAGE.times do |i|
      break if end_job || @block_list.include?(obj[:code])

      query = { a: '24h', button: nil, l: obj[:name], p: i, sp: SP, st: ST }
      log(obj[:name], j, i + 1, 'Начало')
      request = get_list_jobs(query, thread, obj[:name], i + 1)
      if request
        if i == 0
          count_ads = request&.css('div#search_info span,  div.search-count span')&.last&.text&.delete(',').to_i
          break if count_ads.nil? || (count_ads == 0)

          count_page = count_ads / 10
          count_page += 1 if count_ads % 10 > 0
          log(obj[:name], j, i + 1, "Количество страниц всего #{count_page}")
          iter = count_page > MAX_PAGE ? MAX_PAGE : count_page
        end
        @queue_for_prepare_jobs.push(jobs: request.css('div.result, a.result, div.job'),
                                     location: obj[:code],
                                     location_name: obj[:name],
                                     page: i + 1)
        end
      break if (i + 1) == iter
    end
  end

  def get_list(list_of_jobs, thread)
    end_job = false
    log(list_of_jobs[:location_name], thread, list_of_jobs[:page], "На странице #{list_of_jobs[:jobs].count} работ")
    end_job = true if list_of_jobs[:jobs].count == 0
    list_of_jobs[:jobs].each do |job|
      title = job.at_css('a.jobtitle, a.job')
      if how_long(job.at_css('span.date')&.text, thread, list_of_jobs[:location_name], list_of_jobs[:page], title[:title])
        url = @host + title[:href][0..title[:href].index('?') - 1]
        company = job.at_css('div span.company')&.text
        log(list_of_jobs[:location_name], thread, list_of_jobs[:page], "title: #{title[:title]} | company: #{company}")
        if company
          compare = compare_with_index(url: url, title: title[:title], company: company, location_id: list_of_jobs[:location], thread: thread, location: list_of_jobs[:location_name], page: list_of_jobs[:page])
          if compare == :same_sources
            end_job = true
            @block_list.push(list_of_jobs[:location])
            break
          elsif %i[same_title_and_company block_list].include?(compare)
            nil
          else
            salary = job.at_css('div div.salary')&.text&.gsub(',', '')&.scan(/\d+/)
            @queue_tasks_get_jobs.push(link: url,
                                       title: title[:title],
                                       company: company,
                                       salary_min: salary.present? ? salary[0] : nil,
                                       salary_max: salary.present? ? salary[1] : nil,
                                       location: list_of_jobs[:location],
                                       location_name: list_of_jobs[:location_name],
                                       page: list_of_jobs[:page])
          end
        else
          log(list_of_jobs[:location_name], thread, list_of_jobs[:page], "ВНИМАНИЕ для #{title[:title]} компания пуста")
        end
      else
        log(list_of_jobs[:location_name], thread, list_of_jobs[:page], "title: #{title[:title]} Работа старая")
      end
    end
    end_job
  end

  def get_list_jobs(arg, thread, location, page)
    arg[:p] += 1
    arg.delete(:p) if arg[:p] == 1
    super
  end

  def get_job(obj, thread)
    log(obj[:location_name], thread, obj[:page], "title: #{obj[:title]} работа ---> url: #{obj[:link]}")
    job = get_page(obj[:link])
    apply_link = job&.css('a.apply_link')&.first
    apply = apply_calculate(obj, apply_link)
    log(obj[:location_name], thread, obj[:page], "title: #{obj[:title]} apply_link #{apply}")
    description = job&.at_css('div.summary')&.children
    if description
      @queue_jobs_for_save.push(link: obj[:link],
                                title: obj[:title],
                                company: obj[:company],
                                salary_min: obj[:salary_min],
                                salary_max: obj[:salary_max],
                                location: obj[:location],
                                location_name: obj[:location_name],
                                description: html_to_markdown(description),
                                apply: apply)
    else
      log(obj[:location_name], thread, obj[:page], "title: #{obj[:title]} ERROR description is null #{obj[:link]}")
      nil
    end
  end

  def apply_calculate(obj, apply_link)
    if obj[:company] == 'Jora Local'
      jora_local_apply(@host + apply_link[:href])
    else
      apply_link ? @host + apply_link[:href] : obj[:link]
    end
  end

  def jora_local_apply(url)
    url = URI(Nokogiri::HTML(@proxy.redirect(url)).at_css('a')[:href])
    url.query = { tracking: :jobsgalore, utm_source: :jobsgaloreeu, utm_campaign: :jobsgaloreeu, utm_medium: :organic }.to_query
    url.to_s
  rescue StandardError
    puts("Ошибка #{$ERROR_INFO}")
    nil
  end
end
