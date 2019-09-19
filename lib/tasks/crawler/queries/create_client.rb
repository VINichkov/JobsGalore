class CreateClient < Service

  def call(firstname:, location:, company_id:)
    email = "#{firstname.delete("<>{}#@!,.:*&()'`\"’").tr(' ', '_')}#{(0...8).map { rand(97..121).chr }.join}@email.com.au"
    @sql = <<-SQL
            INSERT INTO clients (firstname, lastname, email, location_id, created_at, updated_at, character, send_email, company_id) 
            VALUES ('#{firstname}', 'HR', '#{email}', #{location}, now(), now(),  'employer', false, #{company_id}) 
            RETURNING id
    SQL
    result = super
    result ? result.to_i : result
  end

end