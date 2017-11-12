xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.urlset xmlns:"http://www.sitemaps.org/schemas/sitemap/0.9" do
  @objs.each do |obj|
  xml.url do
    xml.loc obj[:url]
    xml.lastmod obj[:date]
    xml.changefreq obj[:changefreq]
  end
  end
end
