class Indeed < Crawler
  MAX_PAGE = 10
  ST = "date"

  def initialize
    super
    @host = 'https://au.indeed.com'
    @url = 'https://au.indeed.com/jobs?'
    #@local << {name:'Sydney',code:9522}
    Location.select(:id, :suburb, :state).all.each{|city| @local << {name:city.suburb,code:city.id}}
    @count_job = {}
  end

  def run
    super
    puts  @count_job
  end

  def get_main_page(local, j)
    end_job = false
    MAX_PAGE.times do |i|
      break if end_job
      query = {q:nil, l: local[:name],sort: ST, start: i}
      puts "-------Thread:#{j} локация = #{local[:name]} --- страница #{i+1}---------"
      request = get_list_jobs(query)
      end_job = get_list(request, local[:code], j, "#{local[:name]}_#{i}.html")
    end
  end

  def get_list(arg, lacation, j, filename)
    end_job = false
    jobs = arg.css('td#resultsCol div.result, div#jobResults a.result')
    puts "Thread:#{j} На странице #{jobs.count} работ"
    to_file(arg, filename) if jobs.count == 0 or jobs.count >10
    end_job = true if jobs.count == 0
    jobs.each do |job|
      title = job.at_css('a.turnstileLink')
      url = url_to_job(title[:href])
      company = job.at_css('span.company')&.text&.squish
      puts "<<<title: #{title[:title]} | company: #{company}>>>"
      if company
        compare = compare_with_index(url:url, title: title[:title], company:company)
        if compare == :same_sources
          end_job = true
          break
        elsif compare==:same_title_and_company
          nil
        else
          salary = job.at_css('div.salary')&.text&.gsub(',','')&.scan(/\d+/)
          job = get_job(url, j)
          if job
            @jobs.push({link: url,
                        title: title[:title],
                        company: company,
                        salary_min: salary.present? ? salary[0] : nil,
                        salary_max: salary.present? ? salary[1] : nil,
                        location: lacation,
                        apply: job[:apply],
                        description: job[:description]})
          else
            puts "!@@@@ Thread:#{j}  ВНИМАНИЕ для #{url} на получили работу  @@@@!"
          end
        end
      else
        puts "!@@@@ Thread:#{j}  ВНИМАНИЕ для #{title[:title]} компания пуста  @@@@!"
      end
    end
    end_job
  end

  def url_to_job(url)
    if url=~(/^\/company/)
      @host + url
    else
      @host + "/viewjob"+url[url.index('?')..url.length-1]
    end
  end

  def get_list_jobs(arg)
      arg[:start] != 0 ? arg[:start] *=10 : arg.delete(:start)
      url = @url+arg.to_query
      puts "---> Thread:#{j} URL job list = #{url}"
      get_page(url)
  end

  def get_job(url, j)
      puts("->>>Thread:#{j} работа ---> url: #{url}")
      job = get_page(url)
      apply_link = job.css('div#viewJobButtonLinkContainer a, div#jobsearch-ViewJobButtons-container a')
      apply_link = apply_link&.first
      apply = apply_link ? apply_link[:href] : url
      description = job.at_css('div.jobsearch-JobComponent-description')
      if description
        {description: html_to_markdown(job.at_css('div.jobsearch-JobComponent-description').children.to_s), apply:apply}
      else
        puts "Thread:#{j} ERROR description is null #{url}"
        nil
      end
  end

  def create_jobs(job)
      @count_job[job[:location]] ? @count_job[job[:location]] +=1 : @count_job[job[:location]] = 1
      super
  end
end