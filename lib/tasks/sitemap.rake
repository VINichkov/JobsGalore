namespace :sitemap do

  desc "Send daily job alert"
  task :create => :environment  do
    CreateSitemapsJob.perform_later
  end

end