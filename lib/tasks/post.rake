namespace :post do
  desc "Post at Twitter"
  task :twitter => :environment  do
    puts "! Task:Post at Twitter: start"
    t = Time.now
    times_all = 15
    time = t.localtime('+02:00').strftime("%H").to_i
    times_left=times_all-time
    if time > 0 or time<times_all
      companies = Gateway.pluck(:company_id)
      jobs = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all
      if jobs.count !=0
        count = (jobs.count % times_left)>0 ? (jobs.count/times_left +1) : jobs.count/times_left
        jobs[0..count-1].each do |job|
          job.post_at_twitter(Gateway.find_by_company_id(job.company_id).hashtags)
        end
      end
    end
    puts "! Task:Post at Twitter: End"
  end

  desc "Post at Twitter 22.12"
  task :twitter1 => :environment  do
    puts "! Task:Post at Twitter: start"
    companies = Gateway.pluck(:company_id)
    t =Date.parse('2017-12-22')
    jobs = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all
    jobs.each do |job|
      job.post_at_twitter(Gateway.find_by_company_id(job.company_id).hashtags)
    end
    puts "! Task:Post at Twitter: End"
  end

  desc "Post at Twitter 25.12"
  task :twitter4 => :environment  do
    puts "! Task:Post at Twitter: start"
    companies = Gateway.pluck(:company_id)
    t =Date.parse('2017-12-25')
    jobs = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all
    jobs.each do |job|
      job.post_at_twitter(Gateway.find_by_company_id(job.company_id).hashtags)
    end
    puts "! Task:Post at Twitter: End"
  end

  desc "Post at Twitter 23.12"
  task :twitter2 => :environment  do
    puts "! Task:Post at Twitter: start"
    companies = Gateway.pluck(:company_id)
    t =Date.parse('2017-12-23')
    jobs = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all
    jobs.each do |job|
      job.post_at_twitter(Gateway.find_by_company_id(job.company_id).hashtags)
    end
    puts "! Task:Post at Twitter: End"
  end

  desc "Post at Twitter 24.12"
  task :twitter3 => :environment  do
    puts "! Task:Post at Twitter: start"
    companies = Gateway.pluck(:company_id)
    t =Date.parse('2017-12-24')
    jobs = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all
    jobs.each do |job|
      job.post_at_twitter(Gateway.find_by_company_id(job.company_id).hashtags)
    end
    puts "! Task:Post at Twitter: End"
  end
end