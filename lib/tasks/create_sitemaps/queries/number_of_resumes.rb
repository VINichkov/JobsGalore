class NumberOfResumes < NumberOf

  def initialize(connect)
    @sql = 'select count(1) from resumes'
    super(connect)
  end

end