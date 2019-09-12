class NumberOfJobsQuery
  def call
    sql = 'select cast(sum(counts_jobs)*1.3 as numeric(38)) as rez from locations'
    ActiveRecord::Base.connection.exec_query(sql).rows[0][0]
  end
end