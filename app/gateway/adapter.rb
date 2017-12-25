require 'open-uri'
require 'nokogiri'
class Adapter
  def initialize(arg = {})
    @doc = arg[:start_page]
    @host = arg[:host]
  end

  def read (index = nil)
    rez = []
    index = create_index(index)
    loop do
      rez+=list_jobs(index)
      read_all_page
    end
    rez
  end

  private
  def create_index(index = nil)
    index&.map do |elem|
      elem[:date_end] ? elem[:title].to_s + elem[:date_end].strftime('%d.%m.%Y') : elem[:title].to_s
    end
  end

  def read_all_page
    if 1==1
      break
    end
  end

  def delete_all_attr(attr)
    attr = Nokogiri::HTML(attr) if attr.class=="String"
    attr.css('*').each do |elem|
      if elem.count>0 then
        elem.each do |attr, value|
          elem.remove_attribute(attr)
        end
      end
    end
  end

end
