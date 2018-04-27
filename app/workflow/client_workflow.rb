class ClientWorkflow < ApplicationWorkflow

  attr_accessor :client, :class

  def initialize(client=nil)
    @client = client
    @class='ClientWorkflow'
  end

  def self.desirialize(arg=nil)
    if arg
      new(arg["client"]["id"] ? Client.find_by_id(arg["client"]["id"]) : Client.new(arg["client"]))
    else
      new(Client.new)
    end
  end

  def company=(arg)
    @client&.company = arg
  end

  def company
    @client.company
  end

  def url
    super
    switch = {new: url_helpers.new_client_registration_path, not_company: url_helpers.new_company_path, final: nil }
    switch[@state]
  end

  protected
  def update
    if @client.nil?
      @state = :new
      @notice = "Сould you introduce yourself,  please?"
    elsif @client&.character == 'employer' && @client&.company.nil?
      @notice = "Please, enter information about your company."
      @state = :not_company
    else
      @notice = nil
      @state = :final
    end
  end
end