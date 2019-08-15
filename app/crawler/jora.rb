# frozen_string_literal: true

class JoraNew < CrawlerNew
  SP = 'facet_listed_date'

  def initialize
    super
    @host = 'https://au.jora.com'
    @url = 'https://au.jora.com/j?'
  end

  def get_list_jobs(arg, location, page)
    arg[:p] += 1
    arg.delete(:p) if arg[:p] == 1
    super
  end

  private

  def description(job)
     job&.at_css('div.summary')&.children
  end

  def apply_link(job)
    job&.css('a.apply_link')&.first
  end

  def salary(job)
    job.at_css('div div.salary')&.text&.gsub(',', '')&.scan(/\d+/)
  end

  def company(job)
    job.at_css('div span.company')&.text&.squish
  end

  def url_to_job(url)
    @host + url[0..url.index('?') - 1]
  end

  def age_of_job_content(job)
    job.at_css('span.date')&.text
  end

  def title(job)
    job.at_css('a.jobtitle, a.job')
  end

  def create_query(name, i)
    { a: '24h', button: nil, l: name, p: i, sp: SP, st: ST }
  end

  def count_ads(arg)
    arg&.css('div#search_info span,  div.search-count span')&.last&.text&.delete(',').to_i
  end

end
