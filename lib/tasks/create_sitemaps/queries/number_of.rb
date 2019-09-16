class NumberOf

  def initialize(connect)
    @connect = connect
  end

  def call
    @connect.exec_params(@sql)[0]["count"].to_i
  end

end