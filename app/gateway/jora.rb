class Jora < Crawler
  SP = "facet_listed_date"
  MAX_PAGE = 2
  ST = "date"

  def initialize
    super
    @host = 'https://au.jora.com'
    @url = 'https://au.jora.com/j?'
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
    count_page = nil
    iter = nil
    MAX_PAGE.times do |i|
      break if end_job
      query = {a: '24h',button:nil, l: local[:name], p: i,  sp: SP, st:ST}
      puts "-------Thread:#{j} локация = #{local[:name]} --- страница #{i+1}---------"
      request = get_list_jobs(query)
      if i==0
        count_ads =  request&.css('div#search_info span,  div.search-count span')&.last&.text&.delete(',').to_i
        if count_ads.nil? or count_ads==0
          #to_file(request, "#{local[:name]}_#{i}.html")
          break
        end
        count_page = count_ads / 10
        count_page +=1 if (count_ads % 10 > 0)
        puts "! Thread:#{j} Количество страниц всего #{count_page}"
        iter  = count_page > MAX_PAGE ? MAX_PAGE : count_page
      end
      end_job = get_list(request, local[:code], j)
      break if (i + 1 ) == iter
    end
  end

  def get_list(arg, lacation, j)
    end_job = false
    jobs = arg.css('ul#jobresults li.result')
    puts "Thread:#{j} На странице #{jobs.count} работ"
    #to_file(arg, filename) if job.count == 0
    jobs.each do |job|
      title = job.at_css('a.jobtitle, a.job')
      url = @host + title[:href][0..title[:href].index('?') - 1]
      company = job.at_css('div span.company')&.text
      puts "<<<title: #{title[:title]} | company: #{company}>>>"
      if company
        compare = compare_with_index(url:url, title: title[:title], company:company)
        if compare == :same_sources
          end_job = true
          break
        elsif compare==:same_title_and_company
          nil
        else
          salary = job.at_css('div div.salary')&.text&.gsub(',','')&.scan(/\d+/)
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

  def get_list_jobs(arg)
      arg[:p] +=1
      arg.delete(:p) if arg[:p] == 1
      url = @url+arg.to_query
      puts "---> Thread:#{j} URL job list = #{url}"
      get_page(url)
  end

  def get_job(url, j)
      puts("->>>Thread:#{j} url: #{url}")
      job = get_page(url)
      apply_link = job.at_css('a[class="button apply_link"]')
      apply = apply_link ? @host +apply_link[:href] : url
     {description: html_to_markdown(job.at_css('div.summary').children.to_s), apply:apply}
  end

  def create_jobs(job)
      @count_job[job[:location]] ? @count_job[job[:location]] +=1 : @count_job[job[:location]] = 1
      super
  end
end