class ResumeWorkflow < ApplicationWorkflow

  attr_accessor :resume, :client

  def initialize(resume, client = nil)
    @resume = resume
    @class='ResumeWorkflow'
    @client =client
    if @resume.client.nil? and @resume
      @resume.client = @client
    end
    Rails.logger.debug("ResumeWorkflow::initialize  = #{self.to_json}")
  end

  def self.desirialize(arg=nil)
    if arg
      Rails.logger.debug("ResumeWorkflow::desirialize #{arg.to_json}")
      if arg["resume"]
        if arg["client"]
          client = (arg["client"]["id"] ? Client.find_by_id(arg["client"]["id"]) : Client.new(arg["client"]))
          Rails.logger.debug("ResumeWorkflow::desirialize #{arg.to_json}")
        end
        new(arg["resume"]["id"] ? Resume.find_by_id(arg["resume"]["id"]) : Resume.new(arg["resume"]), client)
      else
        new(Resume.new)
      end
    end
  end

  def url
    super
    switch = LazyHash.new(  new: ->{url_helpers.new_resume_path},
                            not_client: ->{url_helpers.new_client_registration_path},
                            not_persisted: ->{url_helpers.resumes_path},
                            final: ->{url_helpers.resume_path(@resume)})
    switch[@state]
  end


  def client=(arg)
    @client = arg
    @client.character = 'applicant'
    @resume&.client = arg
  end

  def update
    Rails.logger.debug("ResumeWorkflow::actualize start #{self.to_json}")
    if @resume.nil?
      @state = :new
    elsif @resume&.client.nil?
      @state = :not_client
    elsif !@resume.persisted?
      @state = :not_persisted
    else
      @state = :final
    end
    Rails.logger.debug("ResumeWorkflow::actualize end #{@state}")
  end

end