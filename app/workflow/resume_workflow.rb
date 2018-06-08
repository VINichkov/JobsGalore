class ResumeWorkflow < ApplicationWorkflow

  attr_accessor :resume, :client

  def initialize(resume, client = nil)
    Rails.logger.debug("!!!ResumeWorkflow::Инициализация")
    @resume = resume
    @class='ResumeWorkflow'
    @client =client
    if @resume.client.nil? and @client
      @resume.client = @client
    end
  end

  def self.desirialize(arg=nil)
    Rails.logger.debug("!!!ResumeWorkflow::Десириализация")
    if arg
      if arg["resume"]
        if arg["client"]
          client = (arg["client"]["id"] ? Client.find_by_id(arg["client"]["id"]) : Client.new(arg["client"]))
        end
        new(arg["resume"]["id"] ? Resume.find_by_id(arg["resume"]["id"]) : Resume.new(arg["resume"]), client)
      else
        new(Resume.new)
      end
    end
  end

  def url
    Rails.logger.debug("!!!ResumeWorkflow::Вычисляем УРЛ")
    super
    switch = LazyHash.new(  new: ->{url_helpers.new_resume_path},
                            not_client: ->{url_helpers.new_client_session_path},
                            not_persisted: ->{url_helpers.resumes_path},
                            final: ->{url_helpers.resume_path(@resume)})
    switch[@state]
  end

  def resume=(arg)
    Rails.logger.debug("!!!ResumeWorkflow::Получаем резюме")
    @resume = arg
    if @resume.client.nil? and @client
      @resume.client = @client
    end
  end

  def client=(arg)
    Rails.logger.debug("!!!ResumeWorkflow::Получаем клиента")
    @client = arg
    unless @client.character
      @client.character = TypeOfClient::APPLICANT
    end
    @resume&.client = arg
  end

  def update
    Rails.logger.debug("!!!ResumeWorkflow::Актуализируем")
    if @resume.nil?
      @state = :new
    elsif @resume&.client.nil? or !@client.persisted?
      @state = :not_client

    elsif !@resume.persisted?
      @state = :not_persisted
    else
      @state = :final
    end
  end

end