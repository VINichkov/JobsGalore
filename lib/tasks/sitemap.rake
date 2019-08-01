namespace :sitemap do
  include Rails.application.routes.url_helpers
  require 'builder'
  NUMBER_OF_ITEMS = 10000
  desc "Send daily job alert"
  task :create => :environment  do
    puts "! Task:add_jobs: start"
    max_page_companies = count_page(Company.count)
    max_page_resumes = count_page(Resume.count)
    max_page_jobs = count_page(Location.select(:counts_jobs).inject(0){|rez, elem| rez +=elem.counts_jobs if elem.counts_jobs}.to_i)
    max_page_companies_with_jobs = count_page(Job.find_by_sql('select j.company_id from jobs j group by j.company_id').count)
    time = Time.now.strftime("%Y-%m-%d")
    @count = max_page_companies + max_page_resumes + max_page_jobs + max_page_companies_with_jobs + 1
    @index = 1
    create_index

    create_files(1) do |i|
      objs = []
      objs << create_item(root_url, time)
      Location.select(:id).order(:id).find_each do |location|
        objs << create_item(local_object_url(location.id, Objects::JOBS.code), time) if location.job.limit(1).present?
        objs << create_item(local_object_url(location.id, Objects::RESUMES.code), time) if location.resume.limit(1).present?
        objs << create_item(local_object_url(location.id, Objects::COMPANIES.code),time) if location.company.limit(1).present?
      end
      create_xml_sitemaps(objs)
    end

    create_files(max_page_companies) do |i|
      objs = []
      Company.select(:id, :updated_at).paginate(page: i, per_page: NUMBER_OF_ITEMS).find_each do |company|
        objs << create_item(company_url(company), company.updated_at.strftime("%Y-%m-%d"))
      end
      create_xml_sitemaps(objs)
    end

    create_files(max_page_resumes) do |i|
      objs = []
      Resume.select(:id, :updated_at).order(:id).paginate(page: i, per_page: NUMBER_OF_ITEMS).find_each do |resume|
        objs << create_item(resume_url(resume), resume.updated_at.strftime("%Y-%m-%d"))
      end
      create_xml_sitemaps(objs)
    end

    create_files(max_page_jobs) do |i|
      objs = []
      Job.select(:id, :updated_at).order(:id).paginate(page: i, per_page: NUMBER_OF_ITEMS).find_each do |job|
        objs << create_item(job_url(job), job.updated_at.strftime("%Y-%m-%d"))
      end
      create_xml_sitemaps(objs)
    end

    create_files(max_page_companies_with_jobs) do |i|
      Company.create_sitemap_jobs("#{Rails.application.routes.default_url_options[:host]}/company_jobs", NUMBER_OF_ITEMS, i, time)
    end


    puts "! Task:add_jobs: End"
  end

  def create_files(count)
    count.times do |i|
      to_file("public/sitemap/sitemaps#{@index}.xml") {yield(i+1)}
      @index +=1
    end
  end


  def create_index
    xml = Builder::XmlMarkup.new()
    xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
    xml.sitemapindex xmlns:"http://www.sitemaps.org/schemas/sitemap/0.9" do
      @count.times do |i|
        xml.sitemap do
          xml.loc sitemap_object_url(i+1)
        end
      end
    end
    to_file("public/sitemap/sitemap.xml") {xml.target!}
  end

  def create_xml_sitemaps(objs)
    xml = Builder::XmlMarkup.new()
    xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
    xml.urlset xmlns:"http://www.sitemaps.org/schemas/sitemap/0.9" do
      objs.each do |obj|
        xml.url do
          xml.loc obj[:url]
          xml.lastmod obj[:date]
          xml.changefreq obj[:changefreq]
        end
      end
    end
    xml.target!
  end

  def to_file(name)
    out_file = File.new(name, "w")
    out_file.puts yield
    out_file.close
  end

  def create_item(url, date, changefreq = 'hourly')
    {url: url, date: date, changefreq: changefreq}
  end

  def count_page(count)
    res = count / NUMBER_OF_ITEMS
    res += 1 if (count % NUMBER_OF_ITEMS)>0
  end
end