class CollectionObjects

  def initialize(connect)
    @connect = connect
  end

  def call(*arg)
    @connect.exec_params(@sql)[0]['result']
  end

end