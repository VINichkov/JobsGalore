class Rmit < Adapter
  def initialize
    super(:start_page=> Nokogiri::HTML(open('http://yourcareer.rmit.edu.au/caw/en/listing')),
          host: "http://yourcareer.rmit.edu.au")
  end

  private

  def read_all_page
    puts "Rmit::read_all_page"
    if @doc.at_css('[class="more-link button"]').blank?
      return true
    else
      @doc = Nokogiri::HTML(open( "#{@host}#{@doc.at_css('[class="more-link button"]')[:href]}"))
      return false
    end
  end

  def list_jobs (index = nil)
    puts "Rmit::list_jobs"
    table = @doc.at_css('[id="recent-jobs-content"]')
    table.css('tr').each do |row|
      if row['class'] != "summary"
        title = row.at_css('[class="job-link"]').content.gsub('/', ', ').encode!(Encoding::ISO_8859_1).force_encoding(Encoding::UTF_8)
        close = row.css('time').first&.content
        close ? close = Date.parse(close) : nil
        put_in_jobs(index:index, title:title, close:close, link:"#{@host}#{row.at_css('[class="job-link"]')[:href]}")
      end
    end
  end

  def get_job(url)
    puts "Rmit::get_job"
    puts "Rmit::get_job url #{url}"
    page = Nokogiri::HTML(open(url))
    job = page.at_css('div[id="job-content"]')
    puts "Rmit::get_job Получили job"
    job.css('img').remove
    puts "Rmit::get_job удалили img"
    job.css('div div h1').remove
    puts "Rmit::get_job удалили div div h1"
    job.css('div[id="social-media"]').remove
    puts "Rmit::get_job удалили social-media"
    job.css('a[class="back-link button"]').remove
    puts "Rmit::get_job удалили back-link button"
    #job.css('a[class="apply-link button"]').remove
    job.css('p').each do |p|
      if p.content == " " or p.content == "" or p.content == "  " or p.content == "#Li" or p.content == "#LI"
        p.remove
      end
    end
    puts "Rmit::get_job удалили лишние строки"
    description =''
    unless  job.text.scan(/\w/).empty?
      description += job.children.to_s
      description = html_to_markdown(description)
    end
    {fulltime: description.include?("Full-time"),
     description:description.encode!(Encoding::ISO_8859_1)}
  end

end