class CreateNewJob < Service

  def call(title:, location:, salarymin:, salarymax:, description:, company:, client:, sources:, apply:)
    @sql = <<-SQL
              INSERT INTO jobs (title, location_id, salarymin, salarymax, description, company_id, created_at, updated_at, client_id, close, sources, apply)
              VALUES ('#{title}', #{location}, #{salarymin}, #{salarymax}, '#{description}', #{company}, now(), now(), #{client}, current_date + integer '15', '#{sources}', '#{apply}') 
              RETURNING id as "result"

    SQL
    result = super
    result ? result.to_i : result
  end

end