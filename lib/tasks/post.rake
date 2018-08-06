namespace :post do
  desc "Post at Twitter"
  task :twitter => :environment  do
    puts "! Task:Post at Twitter: start"
    if rand(2)==1
      t = Time.now
      e = Time.now.localtime('+10:00')
      if e >Time.parse('07:00 +1000') and e < Time.parse('22:00 +1000')
        companies = Gateway.pluck(:company_id)
        job = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all.first
        if job
          job.post_at_twitter("#{Gateway.find_by_company_id(job.company_id).hashtags} #{job.title}" )
        else
          job = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t-1.day).all.first
          job.post_at_twitter("#{Gateway.find_by_company_id(job.company_id).hashtags} #{job.title}" ) if job
        end
      end
    end
    puts "! Task:Post at Twitter: End"
  end

end