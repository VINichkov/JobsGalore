require "#{Rails.root}/lib/tasks/db/connect_pg.rb"

require "#{Rails.root}/lib/tasks/crawler/queries/service.rb"
require "#{Rails.root}/lib/tasks/crawler/queries/job.rb"
require "#{Rails.root}/lib/tasks/crawler/queries/company.rb"
require "#{Rails.root}/lib/tasks/crawler/queries/size.rb"
require "#{Rails.root}/lib/tasks/crawler/queries/location.rb"
require "#{Rails.root}/lib/tasks/crawler/queries/create_company.rb"
require "#{Rails.root}/lib/tasks/crawler/queries/create_client.rb"
require "#{Rails.root}/lib/tasks/crawler/queries/find_client.rb"
require "#{Rails.root}/lib/tasks/crawler/queries/create_new_job.rb"

require "#{Rails.root}/lib/tasks/crawler/services/create_job.rb"