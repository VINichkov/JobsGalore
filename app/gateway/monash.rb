require 'markitdown'
class Monash < Adapter
  def initialize
    @doc = Nokogiri::HTML(open('http://careers.pageuppeople.com/513/cw/en/listing'))
  end

  def read
    rez = []
    loop do
      rez<<list_jobs
      if @doc.at_css('[class="more-link button"]')
        @doc = Nokogiri::HTML(open( "http://careers.pageuppeople.com#{@doc.at_css('[class="more-link button"]')[:href]}"))
      else
        break
      end
    end
    puts rez
  end

  private

  def list_jobs
    table_jobs = @doc.at_css('[id="recent-jobs"]')
    table = table_jobs.at_css('[id="recent-jobs-content"]')
    jobs = []
    table.css('tr').each do |row|
      if row['class'] != "summary"
        #ЗП #puts row.css('td')[2].content
        job = get_job "http://careers.pageuppeople.com#{row.at_css('[class="job-link"]')[:href]}"
       jobs.push ({ title: row.at_css('[class="job-link"]').content,
                        date_end:row.css('time').first&.content,
                        fulltime:job[:fulltime],
                        discription:job[:discription]})

      end
    end
    jobs
  end

  def get_job(url)
    page = Nokogiri::HTML(open(url).read)
    job = page.at_css('[class="jobdets"]')
    job.css('span').remove
    job.css('div').remove
    job.css('p').last&.remove
    table = job.css('table')
    table.css('tr').first&.remove
    table_arr = table.css('tr')
    discription = ''
    table_arr.css('td').children.each do |elem|
      discription += elem.to_s
    end
    job.css('table').remove
    discription += "<hr>"
    discription += job.to_s
    {fulltime: discription.include?("Full-time"),
     discription:Markitdown.from_nokogiri(Nokogiri::HTML(discription.gsub("<br>"," ").gsub("</div>",'').gsub("<h2>","<h4>").gsub("<h3>","<h4>").chomp))}
  end
end