require 'open-uri'
require 'nokogiri'
class Adapter
  def initialize(arg = {})
    @jobs, @doc, @host = [], arg[:start_page], arg[:host]
  end

  def read (index = nil)
    index = create_index(index)
    loop do
      list_jobs(index)
      break if read_all_page
    end
    @jobs
  end

  private
  def create_index(index = nil)
    {indexd: indexd(index), index: index(index)}
  end

  def indexd(index)
    index&.map do |elem|
      elem[:date_end] ? elem[:title].to_s + elem[:date_end].strftime('%d.%m.%Y') : elem[:title].to_s
    end
  end

  def index(index)
    index&.map { |elem| elem[:title].to_s}
  end

  def read_all_page
    true
  end

  def put_in_jobs(arg={})
    if arg[:close]
      ad_was_published = arg[:index][:indexd].include?(arg[:title] + arg[:close].strftime('%d.%m.%Y'))
    else
      ad_was_published =arg[:index][:index].include?(arg[:title])
    end
    unless ad_was_published
      job = get_job arg[:link]
      unless job[:description].empty?
        @jobs.push({ title: arg[:title],
                     close: arg[:close],
                     fulltime:job[:fulltime],
                     description:job[:description].force_encoding(Encoding::UTF_8)})
      end
    end
  end

  def update_attr(attr)
    attr = Nokogiri::HTML(attr)
    attr.css('*').each do |elem|
      if elem&.count>0 then
        elem.each do |attr, value|
          if attr != 'href'
            elem.remove_attribute(attr)
          else
            href_edit(elem, attr, value)
          end
        end
      end
    end
    attr.to_s
  end

  def href_edit(elem, attr, value)
    if value[0] == '/'
      elem[:href] = @host+value
    end
  end

  def gsub_html(arg)
    arg.gsub("<span>","").gsub("</span>","").gsub("<div>","").gsub("</div>","").gsub("<br>","").gsub("<h1>","<h4>").gsub("<h2>","<h4>").gsub("</h3>","<h4>").gsub("</h1>","<h4>").gsub("</h2>","<h4>").gsub("<h3>","<h4>").squish.gsub("> <","><")
  end

  def html_to_markdown(arg)
    Markitdown.from_nokogiri(Nokogiri::HTML(gsub_html(update_attr(arg))))
  end

  def industry
    nil
  end



end
