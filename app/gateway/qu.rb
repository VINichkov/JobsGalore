class Qu < Adapter
  def initialize
    super(:start_page=> Nokogiri::HTML(open('http://jobs.uq.edu.au/caw/en/listing/')),
          host: "http://jobs.uq.edu.au")
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
        #ЗП #puts row.css('td')[2].content
        title = row.at_css('[class="job-link"]').content.encode!(Encoding::ISO_8859_1).force_encoding(Encoding::UTF_8)
        close = row.css('time').first&.content
        close ? close = Date.parse(row.css('time').first&.content) : nil
        put_in_jobs(index:index, title:title, close:close, link:"#{@host}#{row.at_css('[class="job-link"]')[:href]}")
      end
    end
  end

  def get_job(url)
      page = Nokogiri::HTML(open(url))
      job = page.at_css('[class="jobdets"]')
      if job.nil?
        job = page.at_css('[id="job-details"]')
      end
      job.css('span')&.remove
      job.css('div')&.remove
      job.css('p')&.last&.remove
      table = job.css('table')
      table.css('tr').first&.remove
      table_arr = table.css('tr')
      description = ''

      job.css('table').remove
      job.css('p').each do |e|
        if not (e.content.to_s.scan(/(To submit an application for this)/).empty?) or e.content =="#Li"
          e.remove
        end
      end
      job.css('img').remove
      unless  job.text.scan(/\w/).empty?
        table_arr.css('td').children.each do |elem|
          description += elem.to_s
        end
        description += "<hr>"
        description += job.children.to_s
        description = html_to_markdown(description) #.squish
      end
      {fulltime: description.include?("Full-time"),
       description:description.encode!(Encoding::ISO_8859_1)}
  end

end