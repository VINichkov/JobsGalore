class NumberOf

  def initialize(connect)
    @connect = connect
  end

  def call
    result = @connect.exec_params(@sql)
    result.to_a.blank? ? false : result[0]['count'].to_i
  end

end