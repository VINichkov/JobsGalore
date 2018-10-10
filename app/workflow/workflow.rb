require "redis"
class Workflow
  def self.new(arg={})
    switch = LazyHash.new(  ClientWorkflow: ->{ClientWorkflow.new(arg)},
                            JobWorkflow: ->{JobWorkflow.new(arg)},
                            ResumeWorkflow: ->{ResumeWorkflow.new(arg)},
                            Redirect: ->{Redirect.new(arg)})
    switch[arg[:class].to_sym]
  end

  def self.save!(object,session)
    Rails.logger.debug  "!! Workflow.save!: object = #{object.to_json}, session.id #{session}"
    redis  = connect()
    redis.set(session, object, ex:3600)
  end

  def self.find_by_session(arg)
    Rails.logger.debug  "!! Workflow.find_by_session!: #{arg.to_json}"
    redis  = connect()
    response = redis.get(arg)
    Rails.logger.debug  "!! Workflow.find_by_session!: нашли  #{response}"
    if response
      object = JSON.parse(response, opts={symbolize_names:true})
      object ? self.new(object) : false
    else
      nil
    end
  end

  private
  def self.connect()
    Connect.instance.redis
  end

end