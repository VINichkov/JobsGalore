class IndeedNew < CrawlerNew

  def initialize
    super
    @host = 'https://au.indeed.com'
    @url = 'https://au.indeed.com/jobs?'
  end


  def get_list_jobs(arg, location, page)
      arg[:start] != 0 ? arg[:start] *= 10 : arg.delete(:start)
      super
  end


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
    job.at_css('a.turnstileLink')
  end

  def create_query(name, i)
    {l: name, sort: ST, start: i, q:nil}
  end

  def count_ads(arg)
    arg.css('div#searchCount')&.text&.delete(',').scan(/\d+/).last.to_i
  end

end