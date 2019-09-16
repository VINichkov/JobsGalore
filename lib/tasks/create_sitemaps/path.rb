require "#{Rails.root}/lib/tasks/db/connect_pg.rb"

require "#{Rails.root}/lib/tasks/create_sitemaps/queries/number_of.rb"
require "#{Rails.root}/lib/tasks/create_sitemaps/queries/number_of_companies.rb"
require "#{Rails.root}/lib/tasks/create_sitemaps/queries/number_of_companies_with_jobs.rb"
require "#{Rails.root}/lib/tasks/create_sitemaps/queries/number_of_jobs.rb"
require "#{Rails.root}/lib/tasks/create_sitemaps/queries/number_of_resumes.rb"

require "#{Rails.root}/lib/tasks/create_sitemaps/queries/collection_objects.rb"
require "#{Rails.root}/lib/tasks/create_sitemaps/queries/job.rb"
require "#{Rails.root}/lib/tasks/create_sitemaps/queries/resume.rb"
require "#{Rails.root}/lib/tasks/create_sitemaps/queries/company.rb"
require "#{Rails.root}/lib/tasks/create_sitemaps/queries/company_with_jobs.rb"