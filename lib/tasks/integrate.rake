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
    ind = { accounting: Industry.find_by_name('Accounting'),
            adm: Industry.find_by_name('Administration & Secretarial'),
            media: Industry.find_by_name('Advertising, Media, Arts & Entertainment'),
            natural: Industry.find_by_name('Agriculture, Nature & Animal'),
            finance: Industry.find_by_name('Banking & Finance'),
            biotech: Industry.find_by_name('Biotech, R&D, Science'),
            construction: Industry.find_by_name('Construction, Architecture & Interior Design'),
            service: Industry.find_by_name('Customer Service & Call Centre'),
            writing: Industry.find_by_name('Editorial & Writing'),
            edication: Industry.find_by_name('Education, Childcare & Training'),
            engineering: Industry.find_by_name('Engineering'),
            franchise: Industry.find_by_name('Franchise & Business Ownership'),
            goverment: Industry.find_by_name('Government, Defence & Emergency'),
            health: Industry.find_by_name('Health, Medical & Pharmaceutical'),
            hospitality: Industry.find_by_name('Hospitality, Travel & Tourism'),
            hr: Industry.find_by_name('HR & Recruitment'),
            insurance: Industry.find_by_name('Insurance & Superannuation'),
            it: Industry.find_by_name('IT'),
            legal: Industry.find_by_name('Legal'),
            logistics: Industry.find_by_name('Logistics, Supply & Transport'),
            manufacturing: Industry.find_by_name('Manufacturing & Industrial'),
            marketing: Industry.find_by_name('Marketing'),
            mining: Industry.find_by_name('Mining, Oil & Gas'),
            other: Industry.find_by_name('Other'),
            manager: Industry.find_by_name('Program & Project Management'),
            property: Industry.find_by_name('Property & Real Estate'),
            safety: Industry.find_by_name('Quality Assurance & Safety'),
            retail: Industry.find_by_name('Retail'),
            sales: Industry.find_by_name('Sales'),
            security: Industry.find_by_name('Security & Protective Services'),
            trades: Industry.find_by_name('Trades & Services'),
            social: Industry.find_by_name('Voluntary, Charity & Social Work'),
            home: Industry.find_by_name('Work from Home')}
    Job.all.each do |job|
      job.title.downcase!
      i += 1
      if accountant(job.title)
        printr job,i, "Accounting"
        #job.update(industry: int[:accounting])
      elsif administration(job.title)
        printr job,i, "Administration & Secretarial"
        #job.update(industry: int[:adm])
      elsif media(job.title)
        printr job,i, "Advertising, Media, Arts & Entertainment"
        #job.update(industry: int[:media])
      elsif false
        printr job,i, "Agriculture, Nature & Animal"
        job.update(industry: int[:natural])
      elsif finance(job.title)
        printr job,i, "Banking & Finance"
        #job.update(industry: int[:finance)
      elsif science(job.title)
        printr job,i, "Biotech, R&D, Science"
        #job.update(industry: int[:biotech])
      elsif false
        printr job,i, "Construction, Architecture & Interior Design"
        job.update(industry: int[:construction])
      elsif false
        printr job,i, "Customer Service & Call Centre"
        job.update(industry: int[:service])
      elsif false
        printr job,i, "Editorial & Writing"
        job.update(industry: int[:writing])
      elsif education(job.title)
        printr job,i, "Education, Childcare & Training"
        #job.update(industry: int[:edication])
      elsif enginering(job.title)
        printr job,i, "Engineering"
        #job.update(industry: int[:engineering)
      elsif false
        printr job,i, "Franchise & Business Ownership"
        job.update(industry: int[:franchise])
      elsif false
        printr job,i, "Government, Defence & Emergency"
        job.update(industry: int[:goverment])
      elsif medical(job.title)
        printr job,i, "Health, Medical & Pharmaceutical"
        #job.update(industry: int[:health)
      elsif false
        printr job,i, "Hospitality, Travel & Tourism"
        job.update(industry: int[:hospitality])
      elsif hr(job.title)
        printr job,i, "HR & Recruitment"
        #job.update(industry: int[:hr])
      elsif false
        printr job,i, "Insurance & Superannuation"
        job.update(industry: int[:insurance])
      elsif it(job.title)
        printr job,i, "IT"
        #job.update(industry: int[:it])
      elsif false
        printr job,i, "Legal"
        job.update(industry: int[:legal])
      elsif false
        printr job,i, "Logistics, Supply & Transport"
        job.update(industry: int[:logistics])
      elsif false
        printr job,i, "Manufacturing & Industrial"
        job.update(industry: int[:manufacturing])
      elsif false
        printr job,i, "Marketing"
        job.update(industry: int[:marketing])
      elsif false
        printr job,i, "Mining, Oil & Gas"
        job.update(industry: int[:mining])
      elsif manager(job.title)
        printr job,i, "Program & Project Management"
        #job.update(industry: int[:manager])
      elsif property(job.title)
        printr job,i, "Property & Real Estate"
        #job.update(industry: int[:property])
      elsif security(job.title)
        printr job,i, "Quality Assurance & Safety"
        #job.update(industry: int[:safety])
      elsif false
        printr job,i, "Retail"
        job.update(industry: int[:retail])
      elsif false
        printr job,i, "Sales"
        job.update(industry: int[:sales])
      elsif false
        printr job,i, "Security & Protective Services"
        job.update(industry: int[:security])
      elsif false
        printr job,i, "Trades & Services"
        job.update(industry: int[:trades])
      elsif false
        printr job,i, "Voluntary, Charity & Social Work"
        job.update(industry: int[:social])
      elsif false
        printr job,i, "Work from Home"
        job.update(industry: int[:home])
      elsif other(job.title)
        printr job,i, "Other"
        #job.update(industry: int[:other])
      end
    end
  end

  def printr(job,i, text)
    puts "#{i}| ID = #{job.id} - #{job.title} -- #{job.conpany.title} ---  #{text}"
  end
  def accountant (text = nil)
    if text
      text.include?('accountant')
    else
      false
    end
  end
 def finance(text = nil)
   if text
     text.include?('expense') or text.include?('budget') or text.include?('finance') or text.include?('payroll')
   else
     false
   end
 end

  def security(text = nil)
    if text
      text.include?('security') and text.include?('officer')
    else
      false
    end
  end

 def education(text = nil)
  if text
    (text.include?('student') and (text.include?('trainer') or text.include?('administration') or text.include?('analyst'))) or
    (text.include?('manager') and (r text.include?('research') or text.include?('education') or text.include?('school'))) or
    text.include?('phd') or text.include?('laboratory') or
    (text.include?('analyst') and text.include?('information') and text.include?('alumni')) or
    text.include?('research') or text.include?('co-ordinator') or
    text.include?('lecturer') or text.include?('museum') or
    text.include?('academic') or text.include?('course') or
    text.include?('fellow') or text.include?('associate') or
    text.include?('training')  or text.include?('scholar') or
    (text.include?('head') and text.include?('asian')) or
    (text.include?('officer') and (text.include?('programs') or text.include?('admissions') or text.include?('credit') or text.include?('student') or text.include?('membership'))) or
    text.include?('advisor') or text.include?('educational') or text.include?('dean') or text.include?('educator') or text.include?('psychology') or text.include?('scholarship') or
    text.include?('culture') or text.include?('post-doctoral') or text.include?('scientific') or text.include?('education') or text.include?('course') or text.include?('curriculum')
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
      (text.include?('research') and (text.include?'agein')) or text.include?('biomedical') or text.include?('scientist') or text.include?('bioinformatician')
    else
      false
    end
  end

  def administration(text = nil)
    if text
      ((text.include?('assistant') or text.include?('officer')) and (text.include?'timetabling' or text.include?'activities' or text.include?'planning' or text.include?'administration' or text.include?'governance' or text.include?'development' or text.include?'relations' or text.include?'alumni' or text.include?'administrative' or text.include?'support' or text.include?'project' or text.include?'executive')) or
      ((text.include?'information' or text.include?'personal' or text.include?'administrative') and (text.include?'executive' or text.include?'assistant')) or
      text.include?'manager' or
      (text.include?'coordinator') or (text.include?'service desk') or (text.include?'administrator') or
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
      (text.include?('analyst') and (not text.include?('student')) and (text.include?('digital') or text.include?('application') or text.include?('senior') or (text.include?('information') and not (text.include?('alumni')))or text.include?('business'))) or
      text.include?('peoplesoft hcm') or text.include?('ux analysis') or
      (text.include?('science') and text.include?('computer')) or
      (text.include?('user') and text.include?('design')) or
      (text.include?('network')) or (text.include?('sql')) or (text.include?('database')) or
      ((text.include?('senior') or text.include?('website') or text.include?('software')) and (text.include?('design') or text.include?('development') or text.include?('developer'))) or
      (text.include?('solution') and text.include?('architect')) or
      text.include?('analytic') or (text.include?('information') and text.include?('technology'))
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
      (text.include?('hr') or (text.include?('talent')) or (text.include?'human' and text.include?'resources')) or (text.include?('recruitment')) or (text.include?'career' and text.include?'adviser')
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
      text.include?('librar')
    else
      false
    end
  end
end
