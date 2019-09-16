class NumberOfCompaniesWithJobs < NumberOf
  
  def initialize(connect)
    @sql = 'select count(distinct(j.company_id)) from jobs j;'
    super(connect)
  end
  
end