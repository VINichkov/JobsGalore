namespace :post do
  desc "Post at Twitter"
  task :twitter => :environment  do
    puts "! Task:Post at Twitter: start"
    t = Time.now
    #times_all = 15
    #time = t.localtime('+02:00').strftime("%H").to_i
    #times_left=times_all-time
    #if time > 0 or time<times_all
    companies = Gateway.pluck(:company_id)
    jobs = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all
    jobs.first.post_at_twitter("#{Gateway.find_by_company_id(job.company_id).hashtags} #{job.title}" )
      #if jobs.count !=0
        #count = (jobs.count % times_left)>0 ? (jobs.count/times_left +1) : jobs.count/times_left
        #jobs[0..count-1].each do |job|
          #job.post_at_twitter("#{Gateway.find_by_company_id(job.company_id).hashtags} #{job.title}" )
        #end
      #end
    #end
    #
    puts "! Task:Post at Twitter: End"
  end

end