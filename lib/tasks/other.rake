namespace :other do
  desc "Extras check"
  task :extras_check => :environment  do
    puts "! Task:extras_check: start"
    begin
      db = ActiveRecord::Base.connection
      t = Date.today.to_s
      db.execute("update jobs set highlight=null where highlight+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update jobs set urgent=null where urgent+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update jobs set top=null where top+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update resumes set highlight=null where highlight+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update resumes set urgent=null where urgent+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.execute("update resumes set top=null where top+7 < to_date(\'#{t}\',\'YYYY-MM-DD\')")
      db.close
    rescue
      puts "____________________Error: #{$!}"
    end
    puts "! Task:extras_check: End"
  end

  desc "It pings searcher"
  task :ping_searcher => :environment  do
    open("http://google.com/ping?sitemap=#{PropertsHelper::HOST_NAME}/sitemap.xml")
    open("http://www.bing.com/ping?sitemap=#{PropertsHelper::HOST_NAME}/sitemap.xml")
  end
end