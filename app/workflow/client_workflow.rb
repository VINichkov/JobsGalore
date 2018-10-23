class ClientWorkflow < ApplicationWorkflow

  attr_accessor :client

  def initialize(arg ={})
    Rails.logger.debug  "ClientWorkflow.initialize: #{arg.to_json}"
    arg[:client] = (arg[:client][:id] ? Client.find_by_id(arg[:client][:id]) : Client.new(arg[:client])) if arg[:client].class == Hash
    arg[:client] = Client.new if arg[:client].blank?
    update_state({client:arg[:client], company:arg[:company]})
  end

  aasm  do
    state :new, initial:true
    state :not_company
    state :final

    after_all_transitions :log_status_change

    event :update_state, :before=>:update_att do
      transitions :from => :not_company, :to => :final, guard: :final
      transitions :from => :not_company, :to=>:not_company, guard: :not_company
      transitions :from => :new, :to => :final,  guard: :final
      transitions :from => :new, :to => :not_company, guard: :not_company
      transitions :from => :new, :to => :new, guard: :state_is_new
    end

  end

  def to_slim_json
    {class:self.class.to_s, client:@client.to_short_h}.to_json
  end

  private

  def final
    Rails.logger.debug "&&& Final ((@client&.applicant? = #{@client&.applicant?} or (@client&.resp? = #{@client&.resp?} and @client&.company = #{@client&.company.present?})) and @client&.persisted?= #{@client&.persisted?} ) &&&"
    (@client&.applicant? or (@client&.resp? and @client&.company)) and @client&.persisted?
  end

  def not_company
    Rails.logger.debug "&&& Not_company @client&.persisted? = #{@client&.persisted?} and @client&.resp? = #{@client&.resp?} and !@client&.company_id? = #{@client&.company_id?} &&&"
    @client&.persisted? and @client&.resp? and !@client&.company_id?
  end

  def state_is_new
    Rails.logger.debug "&&& State_is_new !((@client&.applicant? = #{@client&.applicant?} or @client&.company = #{@client&.company}) and @client&.persisted? = #{@client&.persisted?}) and !(@client&.persisted? = #{@client&.persisted?} and @client&.resp? = #{@client&.resp?}) &&&"
    !((@client&.applicant? or @client&.company) and @client&.persisted?) and !(@client&.persisted? and @client&.resp?)
  end

  def update_att(arg = {})
    Rails.logger.debug  "-----ClientWorkflow.update_att"
    @client =arg[:client] if arg[:client]
    @client.update(company:arg[:company])  if @client&.company_id.blank? and arg[:company]
  end

end