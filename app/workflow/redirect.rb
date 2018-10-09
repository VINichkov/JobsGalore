class Redirect
  def initialize(session, route = nil)
     @session = session
     if route
       @route = route
       Rails.logger.debug "<--Redirect create #{@route}  session.id = #{@session}  -->"
       save!(session)
     else
       @route =  Workflow.find_by_session(@session)
       Rails.logger.debug "<--Redirect find_by_session #{@route}  session.id = #{@session}  -->"
     end
  end

  def route
    @route
  end

  def route?
    @route ? true : false
  end

  private

  def save!(session)
    Rails.logger.debug "<--Redirect save #{@route}  session.id = #{session} -->"
    Workflow.save!(@route,session)
  end

end
