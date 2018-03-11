require 'singleton'
class ServerDictionary
  include Singleton

  def initialize
    Rails.logger.debug("ServerDictionary::initialize: load dictionary")
    @arr_word ? @arr_word : @arr_word = File.open('db/dictionary.txt').map{|file| file.delete("\n")}
    index
  end

  def where(query=nil, arg={limit:10})
    Rails.logger.debug("ServerDictionary::where query = \'#{query}\' limit = \'#{arg[:limit]}\'")
    rez=[]
    if query
      i=0
      @arr_word[:"#{query[0]}"].each do |name|
        if i<arg[:limit]
          if name >=query
            rez<<{id: i,name:name}
            i+=1
          end
        else
          break;
        end
      end
    end
    rez
  end


  private

  def index
    Rails.logger.debug("ServerDictionary::index: add index")
    t = Time.now
    index = {}
    @arr_word.each do |word|
      index[:"#{word[0]}"] ?  index[:"#{word[0]}"]<<word : index[:"#{word[0]}"] = [word]
    end
    @arr_word = index
  end

end