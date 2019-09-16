class NumberOfJobs < NumberOf

  def initialize(connect)
    @sql = 'select sum(l.counts_jobs) as count from locations l'
    super(connect)
  end

end