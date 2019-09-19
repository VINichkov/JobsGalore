class Company < Service

  def call(name)
    @sql = <<-SQL
              SELECT id as "result"
              FROM companies
              WHERE name = '#{name}' or ('#{name}' = ANY (names))
              LIMIT 1
    SQL
    result = super
    result ? result.to_i : result
  end

end