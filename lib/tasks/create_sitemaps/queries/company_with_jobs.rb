class CompanyWithJobs < CollectionObjects

  def call(page:, limit:, url_pattern:)
    @sql = <<-SQL
              select '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'||array_to_string(
                      ARRAY(
                            SELECT  '<url><loc>#{url_pattern}/'||c.id||'</loc>'||
                                    '<lastmod>'||TO_CHAR(c.updated_at, 'YYYY-mm-dd')||'</lastmod>'||
                                    '<changefreq>hourly</changefreq></url>'
                            FROM (select j.company_id as id ,max(j.updated_at) as updated_at
                            from jobs j
                            group by j.company_id
                            limit  #{limit} OFFSET #{(page-1)*limit}) as c),'')|| '</urlset>' as "result"
    SQL
    super
  end

end