class ClientWorkflow < ApplicationWorkflow

  attr_accessor :client, :class

  def initialize(client=nil)
    @client = client
    @class='ClientWorkflow'
    Rails.logger.debug("ClientWorkflow::initialize  = #{self.to_json}")
  end

  def self.desirialize(arg=nil)
    if arg
      Rails.logger.debug("ClientWorkflow::desirialize #{arg.to_json}")
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
    Rails.logger.debug("new_client_registration_path #{url_helpers.new_client_registration_path}")
    Rails.logger.debug("new_company_path #{url_helpers.new_company_path}")
    switch = {new: url_helpers.new_client_registration_path, not_company: url_helpers.new_company_path, final: nil }
    switch[@state]
  end

  protected
  def update
    Rails.logger.debug("ClientWorkflow::actualization start #{@client.to_json}")
    if @client.nil?
      @state = :new
    elsif @client&.character == 'employer' && @client&.company.nil?
      @state = :not_company
    else
      @state = :final
    end
    Rails.logger.debug("ClientWorkflow::actualization end #{@state}")
  end
end