class NumberOfCompanies < NumberOf
  def initialize(connect)
    @sql = 'select count(1) from companies'
    super(connect)
  end

end