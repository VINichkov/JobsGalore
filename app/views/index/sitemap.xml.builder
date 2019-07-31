xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.sitemapindex xmlns:"http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.sitemap do
    xml.loc sitemap_object_url(1)
  end
  @max_page_companies.times do |i|
    xml.sitemap do
      xml.loc sitemap_object_url(2, page:i+1)
    end
  end
  @max_page_resumes.times do |i|
    xml.sitemap do
      xml.loc sitemap_object_url(3, page:i+1)
    end
  end
  @max_page_jobs.times do |i|
    xml.sitemap do
      xml.loc sitemap_object_url(4, page:i+1)
    end
  end
  xml.sitemap do
    xml.loc sitemap_object_url(5)
  end
  @max_page_companies_with_jobs.times do |i|
    xml.sitemap do
      xml.loc sitemap_object_url(6, page:i+1)
    end
  end
end
