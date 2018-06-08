class JobWorkflow < ApplicationWorkflow

  attr_accessor :job, :client

  def initialize(job, client = nil)
    Rails.logger.debug("!!!JobsWorkflow::Инициализация")
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
    Rails.logger.debug("!!!JobsWorkflow::десириализация")
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
    Rails.logger.debug("!!!JobsWorkflow::Вычисляем УРЛ")
    super
    switch = LazyHash.new(  new: ->{url_helpers.new_job_path},
                            not_client: ->{url_helpers.new_client_session_path},
                            not_company: ->{url_helpers.new_company_path},
                            not_persisted: ->{url_helpers.jobs_path},
                            final: ->{url_helpers.job_path(@job)})
    switch[@state]
  end


  def client=(arg)
    Rails.logger.debug("!!!JobsWorkflow::Получаем клиента #{arg.to_json}")
    @client = arg
    Rails.logger.debug("!!!JobsWorkflow::Получаем клиента: Аргументы 1 #{!(@client.character)} 2 #{@client.resp?} 3 #{!(@client.character or @client.resp?)}")
    if @client.character.blank? or @client.applicant?
      @client.character = TypeOfClient::EMPLOYER
      Rails.logger.debug("!!!JobsWorkflow::Получаем клиента: Обновленный клиент #{arg.to_json}")
      if @client.persisted?
        @client.save!
      end
    end
    @job.client = @client
    @job.company = @client.company
  end

  def company=(arg)
    Rails.logger.debug("!!!JobsWorkflow::получаем компанию")
    @client&.company = arg
    @job&.company = arg
  end

  def company
    @client.company
  end


  def update
    Rails.logger.debug("!!!JobsWorkflow::актуализирунм")
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