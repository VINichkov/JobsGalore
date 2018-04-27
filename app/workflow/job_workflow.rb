class JobWorkflow < ApplicationWorkflow

  attr_accessor :job, :client

  def initialize(job, client = nil)
    @job = job
    @class='JobWorkflow'
    @client =client
    if @job.client.nil? and @client
      @job.client = @client
      if @client.company
        @job.client.company=@client.company
      end
    end
  end

  def self.desirialize(arg=nil)
    if arg
      if arg["job"]
        if arg["client"]
          client = (arg["client"]["id"] ? Client.find_by_id(arg["client"]["id"]) : Client.new(arg["client"]))
        end
        a=new(arg["job"]["id"] ? Job.find_by_id(arg["job"]["id"]) : Job.new(arg["job"]), client)
      else
        a= new(Job.new)
      end
    end
      a
  end

  def url
    super
    switch = LazyHash.new(  new: ->{url_helpers.new_job_path},
                            not_client: ->{url_helpers.new_client_registration_path},
                            not_company: ->{url_helpers.new_company_path},
                            not_persisted: ->{url_helpers.jobs_path},
                            final: ->{url_helpers.job_path(@job)})
    switch[@state]
  end


  def client=(arg)
    @client = arg
    unless @client.character
      @client.character = 'employer'
    end
    @job.client = @client
    @job.company = @client.company
  end

  def company=(arg)
    @client&.company = arg
    @job&.company = arg
  end

  def company
    @client.company
  end


  def update
    Rails.logger.debug("JobsWorkflow::actualize start #{self.to_json}")
    if @job.nil?
      @state = :new
    elsif @job&.client.nil? or !@client.persisted?
      @state = :not_client
    elsif @client&.company.nil?
      @state = :not_company
    elsif !@job.persisted?
      @state = :not_persisted
    else
      @state = :final
    end
    Rails.logger.debug("JobsWorkflow::actualize end #{@state}")
  end

end