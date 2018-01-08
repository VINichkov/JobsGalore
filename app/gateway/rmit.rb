class Rmit < Adapter
  def initialize
    super(:start_page=> Nokogiri::HTML(open('http://yourcareer.rmit.edu.au/caw/en/listing')),
          host: "http://yourcareer.rmit.edu.au")
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
        close ? close = Date.parse(close) : nil
        put_in_jobs(index:index, title:title, close:close, link:"#{@host}#{row.at_css('[class="job-link"]')[:href]}")
      end
    end
  end

  def get_job(url)
    page = Nokogiri::HTML(open(url))
    job = page.at_css('div[id="job-content"]')
    job.css('img').remove
    job.css('div div h1').remove
    job.css('div[id="social-media"]').remove
    job.css('a[class="back-link button"]').remove
    job.css('a[class="apply-link button"]').remove
    job.css('p').each do |p|
      if p.content == " " or p.content == "" or p.content == "  " or p.content == "#Li" or p.content == "#LI"
        p.remove
      end
    end
    description =''
    unless  job.text.scan(/\w/).empty?
      description += job.children.to_s
      description = html_to_markdown(description)
    end
    {fulltime: description.include?("Full-time"),
     description:description.encode!(Encoding::ISO_8859_1)}
  end

end