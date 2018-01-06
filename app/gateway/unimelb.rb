class Unimelb < Adapter
  def initialize
    super(:start_page=> Nokogiri::HTML(open('http://jobs.unimelb.edu.au/caw/en/listing')),
          host: "http://jobs.unimelb.edu.au")
  end

  private

  def read_all_page
    unless @doc.at_css('[class="more-link button"]')
      return true
    else
      @doc = Nokogiri::HTML(open( "#{@host}#{@doc.at_css('[class="more-link button"]')[:href]}"))
      return false
    end
  end

  def list_jobs (index = nil)
    table = @doc.at_css('[id="recent-jobs-content"]')
    table.css('tr').each do |row|
      if row['class'] != "summary"
        title = row.at_css('[class="job-link"]').content.gsub('/', ', ')
        close = row.css('time').first&.content
        close ? close = Date.parse(row.css('time').first&.content) : nil
        put_in_jobs(index:index, title:title, close:close, link:"#{@host}#{row.at_css('[class="job-link"]')[:href]}")
      end
    end
  end

  def get_job(url)
    page = Nokogiri::HTML(open(url))
    job = page.at_css('div[id="leftContent"]')
    #job.css('p')&.last&.remove
    #table = job.css('table')
    #table.css('tr').first&.remove
    #table_arr = table.css('tr')
    description = ''
    #job.css('table').remove
    #job.css('p').each do |e|
    #  if not (e.content.to_s.scan(/(Your application must address the selection criteria. Please refer to)/).empty?) or e.content =="#Li"
    #    e.remove
    #  end
    #end
    job.css('img').remove
    job.css('div[id="jobDetailsContent"] h2').remove
    job.css('p[id="adv"]').remove
    unless  job.text.scan(/\w/).empty?
      #table_arr.css('td').children.each do |elem|
      #  description += elem.to_s
      #end
      #description += "<hr>"
      description += job.children.to_s
      description = html_to_markdown(description)
    end
    {fulltime: description.include?("Full-time"),
     description:description}
  end

end