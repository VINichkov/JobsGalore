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
      db = nil
    rescue
      db.close
      db = nil
      puts "____________________Error: #{$!}"
    end
    puts "! Task:extras_check: End"
  end

  desc "ping to twitter bots"
  task :ping => :environment  do
    begin
      open( "https://botmelbourne.herokuapp.com/")
    rescue
      puts "____________________Error: #{$!}"
    end
  end

  task :count_jobs => :environment  do
    t = Time.now
    puts "! Task:count_jobs: start  #{t}"
    Location.all.each do |t|
      t.update!(counts_jobs: t.job.count)
    end
    puts "! Task:count_jobs: End #{Time.now - t}"
  end

end