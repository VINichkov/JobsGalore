namespace :integrate do
  desc "Executes to add jobs"
  task :add_jobs => :environment  do
    puts "! Task:add_jobs: start"
    Gateway.all.each do |gate|
      puts "! Task:add_jobs: Start: It executes for company \"#{gate.company.name}\""
      gate.execute
      open("http://google.com/ping?sitemap=#{PropertsHelper::HOST_NAME}/sitemap.xml")
      open("http://www.bing.com/ping?sitemap=#{PropertsHelper::HOST_NAME}/sitemap.xml")
      puts "! Task:add_jobs: End: Company's name's \"#{gate.company.name}\""
    end
    puts "! Task:add_jobs: End"
  end

  desc "Deletes unnecessary jobs"
  task :delete_jobs => :environment  do
    puts "! Task:delete_jobs: start"
    Job.delete_jobs
    puts "! Task:delete_jobs: End"
  end
end