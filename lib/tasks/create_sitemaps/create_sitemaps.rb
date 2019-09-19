require "#{Rails.root}/lib/tasks/create_sitemaps/path.rb"

class CreateSitemaps
  PATH = "#{Rails.root}/public/sitemap/"
  NUMBER_OF_ITEMS = 10000
  ENV['RAILS_ENV'] ||= 'development'
  HOST = YAML.load_file("#{Rails.root}/config/application.yml")[ENV['RAILS_ENV']]['HOST']


  def initialize
    @connect = ConnectPg.instance.connect
  end

  def call
    t = Time.now
    puts "! Task:add_jobs: start"
    max_page_companies = count_page(NumberOfCompanies.new(@connect).call)
    max_page_resumes = count_page(NumberOfResumes.new(@connect).call)
    max_page_jobs = count_page(NumberOfJobs.new(@connect).call)
    max_page_companies_with_jobs = count_page(NumberOfCompaniesWithJobs.new(@connect).call)
    @count = max_page_companies + max_page_resumes + max_page_jobs + max_page_companies_with_jobs
    @index = 1
    create_index

    create_files(max_page_companies) do |i|
      Company.new(@connect).call(page: i, limit: NUMBER_OF_ITEMS, url_pattern: "#{HOST}/companies/")
    end

    create_files(max_page_jobs) do |i|
      Job.new(@connect).call(page: i, limit: NUMBER_OF_ITEMS, url_pattern: "#{HOST}/jobs/")
    end

    create_files(max_page_resumes) do |i|
      Resume.new(@connect).call(page: i, limit: NUMBER_OF_ITEMS, url_pattern: "#{HOST}/resumes/")
    end

    create_files(max_page_companies_with_jobs) do |i|
      CompanyWithJobs.new(@connect).call(page: i, limit: NUMBER_OF_ITEMS, url_pattern: "#{HOST}/company_jobs/")
    end

    @connect.close

    puts "! Task:add_jobs: End #{(Time.now - t)*1000} ms"
  end

  private

  def create_files(count)
    count.times do |i|
      to_file("#{PATH}sitemaps#{@index}.xml") {yield(i+1)}
      @index +=1
    end
  end

  def create_index
    to_file("#{PATH}sitemap.xml") do
      '<?xml version="1.0" encoding="UTF-8"?><sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'\
      "#{(1..@count).map {|i| "<sitemap><loc>#{HOST}/sitemaps/#{i}</loc></sitemap>"}.join}"\
      '</sitemapindex>'
    end
  end

  def to_file(name)
    out_file = File.new(name, "w")
    out_file.puts yield
    out_file.close
  end

  def count_page(count)
    res = count / NUMBER_OF_ITEMS
    res += 1 if (count % NUMBER_OF_ITEMS)>0
  end

end