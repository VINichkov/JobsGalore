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
        job.title.downcase!
        i+=1
        puts "#{i}| #{job.title}  ---  #{job.company.name}"
        if false
          job.industryjob.create(industry: Industry.find_by_name('Accounting'))
        elsif administration(job.title)
          puts "#{i}| #{job.title}  ---  Administration & Secretarial"
          #job.industryjob.create(industry: Industry.find_by_name('Administration & Secretarial'))
        elsif media(job.title)
          puts "#{i}| #{job.title}  ---  Advertising, Media, Arts & Entertainment"
          #job.industryjob.create(industry: Industry.find_by_name('Advertising, Media, Arts & Entertainment'))
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
        elsif enginering(job.title)
          puts "#{i}| #{job.title}  ---  Engineering"
          #job.industryjob.create(industry: Industry.find_by_name('Engineering'))
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
          puts "#{i}| #{job.title}  ---  Program & Project Management"
          #job.industryjob.create(industry: Industry.find_by_name('Program & Project Management'))
        elsif property(job.title)
          puts "#{i}| #{job.title}  ---  Property & Real Estate"
          #job.industryjob.create(industry: Industry.find_by_name('Property & Real Estate'))
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
     false
   else
     false
   end
 end

 def education(text = nil)
  if text
    (text.include?('student') and (text.include?('trainer') or text.include?('administration') or text.include?('analyst'))) or
    (text.include?('manager') and (text.include?('research') or text.include?('education') or text.include?('school'))) or
    text.include?('phd') or
    (text.include?('analyst') and text.include?('information') and text.include?('alumni')) or
    (text.include?('research') and (text.include?('officer') or text.include?('assistant') or text.include?('accountant')))or
    text.include?('lecturer') or
    text.include?('academic') or
    ((text.include?('fellow') or text.include?('associate')) and (text.include?('postdoctoral') or text.include?('research') or text.include?('professor'))) or
    text.include?('training') or
    (text.include?('head') and text.include?('asian')) or
    (text.include?('officer') and (text.include?('admissions') or text.include?('credit') or text.include?('student') or text.include?('membership'))) or
    text.include?('advisor') or text.include?('educational') or text.include?('dean') or text.include?('educator') or text.include?('psychology') or text.include?('scholarship') or
    text.include?('culture') or text.include?('post-doctoral') or text.include?('scientific') or text.include?('education')
  else
    false
  end
 end

  def manager(text = nil)
    if text
      (text.include?('project') and text.include?'coordinator') or text.include?('director') or (text.include?('centre') and text.include?'manager') or (text.include?('project') and text.include?'manager')
    else
      false
    end
  end

  def science(text = nil)
    if text
      (text.include?('research') and (text.include?'agein')) or text.include?('biomedical')
    else
      false
    end
  end

  def administration(text = nil)
    if text
      (text.include?('officer') and (text.include?'planning' or text.include?'administration' or text.include?'governance' or text.include?'development' or text.include?'relations' or text.include?'alumni' or text.include?'administrative' or text.include?'support' or text.include?'project' or text.include?'executive')) or
      (text.include?'administrative' and (text.include?'executive' or text.include?'assistant')) or
      ((text.include?'administration' or text.include?'senior' or text.include?'parking') and text.include?'manager') or
      (text.include?'coordinator') or (text.include?'service desk') or
      ((text.include?'development') and (text.include?'manager')) or
      ((text.include?'event') and (text.include?'administration' or text.include?'administrator') )
    else
      false
    end
  end

  def medical(text = nil)
    if text
      (text.include?('anatomy') or text.include?('clinical') or text.include?('nurse') or text.include?('nursing'))
    else
      false
    end
  end

  def it(text = nil)
    if text
      (text.include?('analyst') and (not text.include?('student')) and (text.include?('application') or text.include?('senior') or (text.include?('information') and not (text.include?('alumni')))or text.include?('business'))) or
      text.include?('peoplesoft hcm') or
      (text.include?('science') and text.include?('computer')) or
      (text.include?('user') and text.include?('design')) or
      (text.include?('network')) or (text.include?('sql')) or (text.include?('database')) or
      (text.include?('website') and (text.include?('design') or text.include?('development'))) or
      (text.include?('solution') and text.include?('architect')) or
      text.include?('analytic')
    else
      false
    end
  end

  def property(text = nil)
    if text
      (text.include?('property'))
    else
      false
    end
  end

  def hr(text = nil)
    if text
      (text.include?('hr') or (text.include?('talent')) or (text.include?'human' and text.include?'resources')) or (text.include?('recruitment'))
    else
      false
    end
  end

  def media(text = nil)
    if text
      (text.include?('media') or (text.include?('communications')))
    else
      false
    end
  end

  def enginering(text = nil)
    if text
      (text.include?('technical') and (text.include?('officer')))  or text.include?('engineer')
    else
      false
    end
  end

  def other(text = nil)
    if text
      (text.include?('librarian'))
      false
    end
  end
end
