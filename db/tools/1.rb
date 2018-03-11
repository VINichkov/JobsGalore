class Test
  def initialize
    @arr_word ? @arr_word : @arr_word = File.open('dictionary.txt').map{|file| file.delete("\n")}
    index
  end

  def where(query=nil, arg={limit:10})
    rez=[]
    if query
      i=0
      @arr_word[:"#{query[0]}"].each do |name|
          if i<arg[:limit]
            if name >=query
              i+=1
              rez<<name
            end
          else
            break;
          end
      end
    end
    rez
  end



  def run
  t = Time.now
  100000.times do
    where('a')
  end
  puts (Time.now-t)*1000
  end

  private

  def index
    t = Time.now
    index = {}
    @arr_word.each do |word|
      index[:"#{word[0]}"] ?  index[:"#{word[0]}"]<<word : index[:"#{word[0]}"] = [word]
    end
    @arr_word = index
    puts 'The array indexed at '+((Time.now-t)*1000).to_s+ ' ms'
  end



end

a = Test.new
puts a.where('st')
a.run