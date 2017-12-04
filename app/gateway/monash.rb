require 'markitdown'
class Monash < Adapter
  def initialize
    @doc = Nokogiri::HTML(open('http://careers.pageuppeople.com/513/cw/en/listing'))
  end

  def read (index = nil)
    rez = []
    index = create_index(index)
    loop do
      rez+=list_jobs(index)
      unless @doc.at_css('[class="more-link button"]')
        break
      end
      @doc = Nokogiri::HTML(open( "http://careers.pageuppeople.com#{@doc.at_css('[class="more-link button"]')[:href]}"))
    end
    rez
  end

  private

  def list_jobs (index = nil)
    table = @doc.at_css('[id="recent-jobs-content"]')
    jobs = []
    table.css('tr').each do |row|
      if row['class'] != "summary"
        #ЗП #puts row.css('td')[2].content
        title = row.at_css('[class="job-link"]').content
        date_end = row.css('time').first&.content
        date_end ? date_end = Date.parse(row.css('time').first&.content) : nil
        unless index&.include?(date_end ? title + date_end.strftime('%d.%m.%Y') : title)
          puts "http://careers.pageuppeople.com#{row.at_css('[class="job-link"]')[:href]}"
          job = get_job "http://careers.pageuppeople.com#{row.at_css('[class="job-link"]')[:href]}"
          jobs.push ({ title: title,
                          close: date_end,
                          fulltime:job[:fulltime],
                          description:job[:description]})
        end
      end
    end
    jobs
  end

  def get_job(url)
    begin
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
      table_arr.css('td').children.each do |elem|
          description += elem.to_s
      end
      job.css('table').remove
      job.css('p').each do |e|
        if not (e.content.to_s.scan(/(Your application must address the selection criteria. Please refer to)/).empty?) or e.content =="#Li"
          e.remove
        end
      end
      job.css('img').remove
      description += "<hr>"
      description += job.children.to_s
      description = Markitdown.from_nokogiri(Nokogiri::HTML(description.gsub("<br>"," ").gsub("<h1>","<h4>").gsub("<h2>","<h4>").gsub("<h3>","<h4>").gsub("</h2>","</h4>").gsub("</h3>","</h4>").squish.gsub("> <","><")))
      {fulltime: description.include?("Full-time"),
       description:description}
    rescue
      puts "!__________________________Ошибка Monash get_jobs!!!"
    end
  end

  def create_index(index = nil)
    index&.map do |elem|
      elem[:date_end] ? elem[:title].to_s + elem[:date_end].strftime('%d.%m.%Y') : elem[:title].to_s
    end
  end

end