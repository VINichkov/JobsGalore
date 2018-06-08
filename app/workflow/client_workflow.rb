class ClientWorkflow < ApplicationWorkflow

  attr_accessor :client, :class

  def initialize(client=nil)
    Rails.logger.debug("!!!ClientWorkflow::Инициализация")
    @client = client
    @class='ClientWorkflow'
  end

  def self.desirialize(arg=nil)
    Rails.logger.debug("!!!ClientWorkflow::десириализация")
    if arg
      new(arg["client"]["id"] ? Client.find_by_id(arg["client"]["id"]) : Client.new(arg["client"]))
    else
      new(Client.new)
    end
  end

  def company=(arg)
    Rails.logger.debug("!!!ClientWorkflow::получаем компанию")
    @client&.company = arg
  end

  def company
    @client.company
  end

  def url
    Rails.logger.debug("!!!ClientWorkflow::вычисляем УРЛ")
    super
    switch = {new: url_helpers.new_client_session_path, not_company: url_helpers.new_company_path, final: nil }
    switch[@state]
  end

  protected
  def update
    Rails.logger.debug("!!!ClientWorkflow::актуализируем")
    if @client.nil?
      @state = :new
    elsif @client&.character == TypeOfClient::EMPLOYER && @client&.company.nil?
      @state = :not_company
    else
      @state = :final
    end
  end
end