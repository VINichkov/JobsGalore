namespace :sitemap do

  desc "Send daily job alert"
  task :create  do
    require "#{Rails.root}/lib/tasks/create_sitemaps/create_sitemaps.rb"
    CreateSitemaps.new.call
  end

end