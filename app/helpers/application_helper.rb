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

  def title(text)
    content_for :title, text
  end
  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end
  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end
end
