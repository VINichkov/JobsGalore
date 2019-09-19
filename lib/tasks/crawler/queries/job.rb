class Job < Service

  def call(location:, sources:, title:, company:)
    @sql = <<-SQL
              SELECT j.id, j.sources, j.title
              FROM jobs j
              WHERE j.location_id = #{location} 
                    AND j.company_id = #{company}
                    AND (j.sources = '#{sources}'
                      or j.title = '#{title}')
              LIMIT 1
    SQL
    result = @connect.exec_params(@sql)
    result.to_a.blank? ? false : result[0]
  end

end