class Qut < Adapter
  def initialize
    @host1 = 'https://qut.nga.net.au'
    point = (Nokogiri::HTML(open('https://qut.nga.net.au/cp/'))).css("div[class=\"cp_jobsListFilter cp_jobsListFilterAlt cp_jobsListFilter2\"] div[class=\"cp_jobsListFilterItem\"] div[class=\"cp_jobsListFilterTitle\"] h2 a")&.first['href']
    super(:start_page=> Nokogiri::HTML(open("#{@host1}#{point}")),
          host: 'https://qut.nga.net.au/cp/')
  end

  private

  def list_jobs (index = nil)
    jobs=[]
    @doc.css('table[class="cp_displayTable footable"] tr').each do |row|
      title = row.css('td a')&.first&.content
      date_end=''
      if title and title&.scan(/Upload/)&.empty?
        begin
          date_end ? date_end = Date.parse(row.css('td[class="cp_closingDate"]')&.first.text) : nil
        rescue
          date_end=nil
        end
        unless index&.include?(date_end ? title + date_end.strftime('%d.%m.%Y') : title)
          job = get_job "#{@host}#{row.css('td[class="cp_jobDetails"] a')&.first["href"]}"
          unless job[:description].empty?
            jobs.push ({ title: title,
                         close: date_end,
                         fulltime:job[:fulltime],
                         description:job[:description]})
          end
        end
      end
    end
    jobs
  end


  def get_job(url)
    page = Nokogiri::HTML(open(url))
    description = page.css('div[class="cp_content"] tr').map do |tr|
      row= tr.css('td').map do |td|
        td.children.to_s
      end
      "<p>#{row.join(' ')}</p>".gsub('<br>',' ')
    end
    link = page.css('div[class="cp_content"] p a').map do |a|
      if not(a["href"].scan(/^mailto:/).empty?)
        "<p><a href=\"#{a["href"]}\">#{a.text}</a></p>"
      else
        a.css('span').remove
        a["href"]="#{@host1}#{a["href"]}"
        "<p>#{a.to_s}</p>".gsub('<br>',' ')
      end
    end
    description = description.join("\r\n") +"\r\n" + link.join("\r\n")
    description = Markitdown.from_nokogiri(Nokogiri::HTML(description))
    {fulltime: description.include?("full-time"),
     description: description}
  end

end