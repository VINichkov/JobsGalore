class TimeExecut
  def self.ms(name = 'method')
    t = Time.new
    res = yield
    Rails.logger.debug("#{name}: #{(Time.new-t) * 1000} ms")
    res
  end
end