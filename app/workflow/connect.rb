class Connect
  include Singleton
  def instance
    @redis ||= Redis.new(url: ENV["REDIS_URL"])
  end

end