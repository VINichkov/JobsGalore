class Service

  def initialize(connect)
    @connect = connect
  end

  def call(*arg)
    result = @connect.exec_params(@sql)
    result.to_a.blank? ? false : result[0]['result']
  end

end