module ApplicationHelper
  def extras_off
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
  end
  def extras_on
    begin
      db = ActiveRecord::Base.connection
      t = Date.today-8
      db.execute("update jobs set highlight=to_date(\'#{t.to_s}\',\'YYYY-MM-DD\') where highlight is null")
      db.execute("update jobs set urgent=to_date(\'#{t.to_s}\',\'YYYY-MM-DD\') where urgent is null")
      db.execute("update jobs set top=to_date(\'#{t.to_s}\',\'YYYY-MM-DD\') where top is null")
      db.execute("update resumes set highlight=to_date(\'#{t.to_s}\',\'YYYY-MM-DD\') where highlight is null")
      db.execute("update resumes set urgent=to_date(\'#{t.to_s}\',\'YYYY-MM-DD\') where urgent is null")
      db.execute("update resumes set top=to_date(\'#{t.to_s}\',\'YYYY-MM-DD\') where top is null")
      db.close
    rescue
      puts "____________________Error: #{$!}"
    end
  end
end
