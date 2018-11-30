class Proxy
  def connect(arg = 'https://rbc.ru')
    arg= {url: arg}
    flag = true
    respond = nil
    i = 0
    while flag and i<3 do
      begin
        i +=1
        respond = open('https://blooming-lake-12024.herokuapp.com/open?' +arg.to_query).read
        flag = false
      rescue
        puts("Ошибка #{$!}")
        flag = true
      end
    end
    respond
  end

end