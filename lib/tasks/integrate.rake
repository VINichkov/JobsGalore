namespace :integrate do
  desc "Executes to add jobs"
  task :add_jobs => :environment  do
    puts "! Task:add_jobs: start"
    begin
      open("http://google.com/ping?sitemap=#{PropertsHelper::HOST_NAME}/sitemap.xml")
      open("http://www.bing.com/ping?sitemap=#{PropertsHelper::HOST_NAME}/sitemap.xml")
    rescue
      puts "____________________Error: #{$!}"
    end
    puts "! Task:add_jobs: End"
  end

  task :destroy_jobs => :environment do
    puts "! Task:Destroy: start #{Time.now}"
    Job.where("close <= :data and urgent is null and top is null and highlight is null", data: Time.now).delete_all
    time = Time.new 2019,3,10,0,0,0
    if Time.now < time
      Job.where("created_at <= :data and urgent is null and top is null and highlight is null", data: Time.now - 15.days).delete_all
    end
    biggest_company
    puts "! Task:Destroy: end #{Time.now}"
  end

  task :jora => :environment  do
    t = Time.now
    puts "! Task:Jora: start #{t}"
    Jora.new.run
    puts "! Task:Jora: End #{Time.now}   - #{Time.now - t}"
  end

  task :indeed => :environment  do
    t = Time.now
    puts "! Task:Indeed: start #{t}"
    Indeed.new.run
    puts "! Task:Indeed: End #{Time.now}   - #{Time.now - t}"
  end

  def biggest_company
    Company.where("id in (select q.id from (select c.name, c.id, count(c.id)/15 as cou from companies c, jobs j where c.id = j.company_id group by c.id) q where q.cou >= 3)").update_all(big: true)
    Company.where("id not in (select q.id from (select c.name, c.id, count(c.id)/15 as cou from companies c, jobs j where c.id = j.company_id group by c.id) q where q.cou >= 3)").update_all(big: false)
  end
end
