require "redis"
class Variable

  attr_accessor :value
  attr_reader :id

  def initialize(value=nil, id = nil)
    @value = value
    @id = id || SecureRandom.uuid
  end


  def self.find_by_id(id)
    Rails.logger.debug  "id = #{id}"
    if id.present?
      redis  =  connect()
      response = redis.get(id)
      if response
        Rails.logger.debug  "Получили =   #{response}"
        self.new(JSON.parse(response, opts={symbolize_names:true}), id)
      else
        Rails.logger.debug  "ничего не нашли"
        nil
      end
    end
  end

  def save
    Rails.logger.debug  "Сохраняем переменную #{@value}"
    redis  = self.class.connect()
    redis.set(@id, @value.to_json.to_s, ex:7200)
  end

  private
  def self.connect()
    Connect.instance.redis
  end
end