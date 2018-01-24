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

  desc "Update industries"
  task :update_jobs => :environment do
    i=0
    Job.all.each do |job|
      if job.industryjob.count == 0
        i+=1
        #puts "#{i}| #{job.title}  ---  #{job.company.name}"
        if false
          job.industryjob.create(industry: Industry.find_by_name('Accounting'))
        elsif administration(job.title)
          puts "#{i}| #{job.title}  ---  Administration & Secretarial"
          #job.industryjob.create(industry: Industry.find_by_name('Administration & Secretarial'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Advertising, Media, Arts & Entertainment'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Agriculture, Nature & Animal'))
        elsif finance(job.title)
          puts "#{i}| #{job.title}  ---  Banking & Finance"
          #job.industryjob.create(industry: Industry.find_by_name('Banking & Finance'))
        elsif science(job.title)
          puts "#{i}| #{job.title}  ---  Biotech, R&D, Science"
          #job.industryjob.create(industry: Industry.find_by_name('Biotech, R&D, Science'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Construction, Architecture & Interior Design'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Customer Service & Call Centre'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Editorial & Writing'))
        elsif education(job.title)
          puts "#{i}| #{job.title}  ---  Education, Childcare & Training"
          #job.industryjob.create(industry: Industry.find_by_name('Education, Childcare & Training'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Engineering'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Franchise & Business Ownership'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Government, Defence & Emergency'))
        elsif medical(job.title)
          puts "#{i}| #{job.title}  ---  Health, Medical & Pharmaceutical"
          #job.industryjob.create(industry: Industry.find_by_name('Health, Medical & Pharmaceutical'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Hospitality, Travel & Tourism'))
        elsif hr(job.title)
          puts "#{i}| #{job.title}  ---  HR & Recruitment"
          #job.industryjob.create(industry: Industry.find_by_name('HR & Recruitment'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Insurance & Superannuation'))
        elsif it(job.title)
          puts "#{i}| #{job.title}  ---  IT"
          #job.industryjob.create(industry: Industry.find_by_name('IT'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Legal'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Logistics, Supply & Transport'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Manufacturing & Industrial'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Marketing'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Mining, Oil & Gas'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Other'))
        elsif manager(job.title)
          puts "#{i}| #{job.title}  ---  Program & Project Manageme"
          #job.industryjob.create(industry: Industry.find_by_name('Program & Project Management'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Property & Real Estate'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Quality Assurance & Safety'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Retail'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Sales'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Security & Protective Services'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Trades & Services'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Voluntary, Charity & Social Work'))
        elsif false
          job.industryjob.create(industry: Industry.find_by_name('Work from Home'))
        elsif other(job.title)
          puts "#{i}| #{job.title}  ---  Otherl"
          #job.industryjob.create(industry: Industry.find_by_name('Other'))
        end
      end
    end
  end

 def finance(text = nil)
   if text
     true
   else
     false
   end
 end

 def education(text = nil)
  if text
    (text.include?('Student') and text.include?('Trainer'))
  else
    false
  end
 end

  def manager(text = nil)
    if text
      (text.include?('Project') and text.include?'Coordinator') or text.include?('Manager') or text.include?('Director')
    else
      false
    end
  end

  def science(text = nil)
    if text
      (text.include?('RESEARCH') and (text.include?'AGEING')) or text.include?('PhD')
    else
      false
    end
  end

  def administration(text = nil)
    if text
      (text.include?('OFFICER') and (text.include?'RELATIONS' or text.include?'ALUMNI' or text.include?'ADMINISTRATIVE' or text.include?'SUPPORT' or text.include?'Project')) or (text.include?'ADMINISTRATIVE' and text.include?'Executive')
    else
      false
    end
  end

  def medical(text = nil)
    if text
      (text.include?('Anatomy') or text.include?('Clinical'))
    else
      false
    end
  end

  def it(text = nil)
    if text
      (text.include?('Analyst') and text.include?('Information')) or text.include?('PeopleSoft HCM')
    else
      false
    end
  end

  def hr(text = nil)
    if text
      (text.include?('HR'))
    else
      false
    end
  end

  def other(text = nil)
    if text
      (text.include?('Librarian'))
    else
      false
    end
  end
end
