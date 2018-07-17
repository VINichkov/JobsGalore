namespace :post do
  desc "Post at Twitter"
  task :twitter => :environment  do
    puts "! Task:Post at Twitter: start"
    if rand(2)==1
      t = Time.now
      companies = Gateway.pluck(:company_id)
      job = Job.where('company_id in (?) and date_trunc(\'day\',created_at)=date(?) and twitter is null',companies,t).all.first
      job.post_at_twitter("#{Gateway.find_by_company_id(job.company_id).hashtags} #{job.title}" )
    end
    puts "! Task:Post at Twitter: End"
  end

end