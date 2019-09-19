class FindClient < Service

  def call(company_id)
    @sql = <<-SQL
              SELECT id as "result"
              FROM client
              WHERE company_id = #{company_id}
              LIMIT 1
    SQL
    result = super
    result ? result.to_i : result
  end

end