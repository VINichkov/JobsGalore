namespace :integrate do
  desc "Executes to add jobs"
  task :add_jobs => :environment  do
    puts "! Task:add_jobs: start"
    Gateway.all.each do |gate|
      puts "! Task:add_jobs: Start: It execute for company \"#{gate.company.name}\""
      gate.execute_getway
      puts "! Task:add_jobs: End: Company's name's \"#{gate.company.name}\""
    end
    puts "! Task:add_jobs: End"
  end
end