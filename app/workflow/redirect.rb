class Redirect

  def initialize(arg ={})
    Rails.logger.debug  "Redirect.initialize: #{arg.to_json} "
    @route = arg[:route]
  end

  def route
    @route
  end

  def update_state(arg={});  end

  def to_slim_json
    {class:self.class.to_s,route:@route}.to_json
  end

  def route?
    @route ? true : false
  end

  def save!(session)
    Rails.logger.debug "<--Redirect save #{to_slim_json}  session.id = #{session} -->"
    Workflow.save!(@route,session)
  end

end
