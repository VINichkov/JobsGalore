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
end
