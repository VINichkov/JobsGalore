module Other
  extend ActiveSupport::Concern

  def self.create_sitemap(url, limit, page , table_name, time=nil)
    data_update = time ? "'<lastmod>#{time}</lastmod>'" : "'<lastmod>'||TO_CHAR(\"#{table_name}\".\"updated_at\", 'YYYY-mm-dd')||'</lastmod>'"
    sql = <<-SQL
              select '<?xml version="1.0" encoding="UTF-8"?><urlset>'||array_to_string(
                      ARRAY(
                            SELECT  '<url><loc>#{url}/'||"#{table_name}"."id"||'</loc>'||
                                    #{data_update}||
                                    '<changefreq>hourly</changefreq></url>'
                            FROM "#{table_name}" 
                            LIMIT #{limit} OFFSET #{(page-1)*limit}),'')|| '</urlset>'
    SQL
    ActiveRecord::Base.connection.exec_query(sql).rows[0][0]
  end
end