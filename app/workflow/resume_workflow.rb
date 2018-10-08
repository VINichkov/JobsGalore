class ResumeWorkflow < ApplicationWorkflow

  attr_accessor :resume, :client

  def initialize(arg={})
    Rails.logger.debug "ResumeWorkflow.initialize: arg[:client].class = #{arg[:client].class}   arg[:resume].class =#{arg[:resume].class},  #{arg.to_json} "
    arg[:client] = (arg[:client][:id] ? Client.find_by_id(arg[:client][:id]) : Client.new(arg[:client])) if arg[:client].class == Hash
    arg[:client] = Client.new if arg[:client].blank?
    arg[:resume] = (arg[:resume][:id] ? Resume.find_by_id(arg[:resume][:id]) : Resume.new(arg[:resume]))  if arg[:resume].class == Hash
    arg[:resume] = Resume.new if arg[:resume].blank?
    update_state({resume:arg[:resume], client: arg[:client]})
  end

  aasm  do
    state :new, initial:true
    state :not_persisted
    state :not_client
    state :final

    after_all_transitions :log_status_change

    event :update_state, :before=>:update_att do
      transitions :from => :new, :to => :new,  guard: :state_is_new
      transitions :from => :new, :to => :not_client, guard: :not_client
      transitions :from => :new, :to => :not_persisted,  guard: :not_persisted
      transitions :from => :new, :to => :final,  guard: :final
      transitions :from => :not_client, :to => :not_client, guard: :not_client
      transitions :from => :not_client, :to => :not_persisted, guard: :not_persisted
      transitions :from => :not_client, :to => :final, guard: :final
      transitions :from => :not_persisted, :to => :final, guard: :final
      transitions :from => :not_persisted, :to => :not_persisted, guard: :not_persisted
    end
  end

  def to_slim_json
    {class:self.class.to_s, client:@client.to_short_h, resume:@resume.to_short_h}.to_json
  end

  private

  def update_att(arg = {})
    Rails.logger.debug "ResumeWorkflow.update_att: #{arg.to_json}"
    @to_start = arg[:to_start]
    @resume =arg[:resume] if arg[:resume]
    if arg[:client]
      @client =arg[:client]
      @resume&.client_id = @client.id if @client.persisted? and @resume&.client_id.nil?
      Rails.logger.debug "!!!  ResumeWorkflow.update_att: @resume&.client_id #{@resume&.client_id} @client.persisted? #{@client.persisted?}"
    end
  end

  def state_is_new
    (not (@resume&.title and @resume&.description)) or @to_start
  end

  def final
    @resume.class == Resume and @resume&.persisted? and @resume&.client_id?
  end

  def not_persisted
    @resume.class == Resume and @resume&.client_id? and !@resume.persisted?
  end

  def not_client
    @resume.class == Resume and !@resume&.client_id? and !@resume.persisted?
  end
end