class CreateCompany < Service

  def call(name:, size:, location:, industry_id:)
    @sql = <<-SQL
              INSERT INTO Companies (name, size_id, location_id, industry_id, created_at, updated_at)
              VALUES (#{name}, #{size}, #{location}, now(), now(), #{industry_id})
              RETURNING id as "result"

    SQL
    result = super
    result ? result.to_i : result
  end

end