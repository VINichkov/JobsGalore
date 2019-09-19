class Location < Service

  def call
    @sql = <<-SQL
              SELECT id, suburb
              FROM locations
            SQL
    result = @connect.exec_params(@sql)
    result.to_a.blank? ? false : result.to_a
  end

end